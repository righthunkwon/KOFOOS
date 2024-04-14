import os
from tqdm import tqdm
import xml.etree.ElementTree as ET
import glob
import yaml

class YoloDataConverter:
     
    def __init__(self, file_path):
        self.FILE_PATH = file_path

        training_path = "train"
        validation_path = "val"
        self.FILE_ANNO_PATH_T = os.path.join(file_path, os.path.join("annotations", training_path))
        self.FILE_ANNO_PATH_V = os.path.join(file_path,os.path.join("annotations", validation_path))
        self.FILE_IMG_PATH_T = os.path.join(file_path,os.path.join("images", training_path))
        self.FILE_IMG_PATH_V = os.path.join(file_path,os.path.join("images", validation_path))
        self.FILE_LABEL_PATH_T = os.path.join(file_path,os.path.join("labels", training_path))
        self.FILE_LABEL_PATH_V = os.path.join(file_path,os.path.join("labels", validation_path))
        self.classes = []

    """
        make_data_yaml() [public]
        : data.yaml 파일 만드는 함수
    """
    def make_data_yaml(self):
        yaml_data = {
            "names": self.classes,                              # 클래스 이름 
            "nc": len(self.classes),                            # 클래스 수
            "path": self.FILE_PATH,                             # root 경로
            "train": os.path.join(self.FILE_PATH, "train.txt"), # train.txt
            "val": os.path.join(self.FILE_PATH, "valid.txt")    # valid.txt
        }

        with open(os.path.join(self.FILE_PATH, "data.yaml"), "w") as f:
            yaml.dump(yaml_data, f)


    """
        make_yolo_labels() [public]
        : annotation xml에서 yolo 형식의 데이터를 만드는 함수
    """
    def make_yolo_labels(self, isTraining):  
        # isTraining: Training(true), Validation(false)
        file_anno_path = self.FILE_ANNO_PATH_T
        file_img_path = self.FILE_IMG_PATH_T
        txt_name = "train.txt"
        
        if not isTraining:
            file_anno_path =self.FILE_ANNO_PATH_V
            file_img_path = self.FILE_IMG_PATH_V
            txt_name = "valid.txt"

        # 하위폴더
        dirs = [dir.name for dir in os.scandir(file_anno_path) if "." not in dir.name] # ex. 과자1
        
        # 라벨을 만듦
        for dir in dirs:
            # 라벨에 하위폴더가 존재하지 않는 경우 생성해준다.
            sub_path = os.path.join(file_anno_path, dir) 
            if not os.path.exists(sub_path):
                os.mkdir(sub_path)

            sub_file_dirs = [file_dir.name for file_dir in os.scandir(sub_path) ] # ex. 10060_해태포키블루베리41G
            for file_dir in sub_file_dirs:
                sub_file_path = os.path.join(sub_path, file_dir)
                files = glob.glob(os.path.join(sub_file_path, '*_meta.xml'))

                for file in tqdm(files):
                    self.__yolo_label(file, dir, file_dir, isTraining)

        
        # 이미지 경로를 저장하는 txt 파일 만들기
        for dir in dirs: #과자1
            sub_path = os.path.join(file_anno_path, dir)
            sub_file_dirs = [file_dir.name for file_dir in os.scandir(sub_path)] # ex. 10060_해태포키블루베리41G
            
            for file_dir in sub_file_dirs:
                sub_file_path = os.path.join(os.path.join(file_img_path, dir), file_dir)
                files = glob.glob(os.path.join(sub_file_path,"*.jpg"))
                with open(os.path.join(self.FILE_PATH, txt_name), 'a') as f:
                    f.write('\n'.join(files) + '\n')

    """
        __make_yolo_bbox(file) [private]
        : 데이터의 annotation xml에서 yolo 라벨을 만드는 함수   
    """
    def __yolo_label(self, file, dir, file_dir, isTraining):
        # isTraining: Training(true), Validation(false)
        file_label_path = self.FILE_LABEL_PATH_T
        if not isTraining:
            file_label_path = self.FILE_LABEL_PATH_V


        basename = os.path.basename(file)
        filename = os.path.splitext(basename)[0].replace("_meta", "")
        
        result = [] # {클래스라벨idx} {x_center} {y_center} {width} {height}

        tree = ET.parse(file)
        root = tree.getroot().find("annotation")

        width = int(root.find("size").find("width").text)
        height = int(root.find("size").find("height").text)
        for obj in root.findall('object'):
            label = obj.find("name").text
            if label not in self.classes:
                self.classes.append(label)

            index = self.classes.index(label)
            pil_bbox = [int(x.text) for x in obj.find("bndbox")]
            yolo_bbox = YoloDataConverter.__get_yolo_bbox(pil_bbox, width, height)
            bbox_string = " ".join([str(x) for x in yolo_bbox])
            result.append(f"{index} {bbox_string}")

        # label 저장
        if result:
            sub_dir_path = os.path.join(file_label_path, dir)
            if not os.path.exists(sub_dir_path):
                os.mkdir(sub_dir_path)

            sub_file_dir_path = os.path.join(sub_dir_path, file_dir)
            if not os.path.exists(sub_file_dir_path):
                os.mkdir(sub_file_dir_path)

            with open(os.path.join(sub_file_dir_path, f"{filename}.txt"), "w", encoding="utf-8") as f:
                f.write("\n".join(result))

    """
        __get_yolo_bbox(bbox, w, h) [private]
        : 데이터의 bounding box에서 yolo에서 사용하는 x,y,w,h 추출하는 함수    
    """
    @classmethod
    def __get_yolo_bbox(cls, bbox, w, h):
        # xmin, ymin, xmax, ymax
        x_center = ((bbox[2] + bbox[0]) / 2) / w
        y_center = ((bbox[3] + bbox[1]) / 2) / h
        width = (bbox[2] - bbox[0]) / w
        height = (bbox[3] - bbox[1]) / h
        return [x_center, y_center, width, height]