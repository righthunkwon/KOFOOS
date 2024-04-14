package com.kofoos.api.product.service;

import com.kofoos.api.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public List<String> findCat2(String cat1){
        return categoryRepository.findCat2(cat1);
    }

    public List<String> findCat3(String cat1,String cat2){
        return categoryRepository.findCat3(cat1,cat2);
    }

    public List<Integer> findId(String cat1,String cat2){
        return categoryRepository.findId(cat1,cat2);
    }

    public List<String> ranking(){
        return categoryRepository.ranking();
    }


}
