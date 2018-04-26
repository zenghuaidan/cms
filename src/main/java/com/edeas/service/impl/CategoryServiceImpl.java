package com.edeas.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.Category;

@Service(value="categoryService")
@Transactional
public class CategoryServiceImpl extends BasicServiceImpl {
	
	public List<Category> findAll() {
		return categoryDao.findAllWithOrderAsc();
	}		
	
	public Category addCategory(Category category) {
		List<Category> categories = findAll();
		category.setCorder(categories.size() == 0 ? 1 : categories.get(categories.size() - 1).getCorder() + 1);
		return categoryDao.add(category);
	}

	public Category findById(Long id) {
		return categoryDao.getById(id);
	}
	
	public void deleteById(Long id) {
		categoryDao.delete(id);
	}

	public void update(Category category) {
		categoryDao.update(category);
	}

	public void chgOrder(Long id, Long beforeId) {
		List<Category> categories = findAll();
		Category thiscat = findById(id);
		
        if (beforeId > 0)
        {
            Category beforecat = findById(beforeId);
            int newo = beforecat.getCorder() - 1;

            if (beforecat.getCorder() > thiscat.getCorder())
            {
                for(Category category : categories) {
                	if (category.getCorder() > thiscat.getCorder() && category.getCorder() < beforecat.getCorder())
                		category.setCorder(category.getCorder() - 1);
                }
            }
            else if (beforecat.getCorder() < thiscat.getCorder())
            {
                newo = beforecat.getCorder();              
                for(Category category : categories) {
                	if (category.getCorder() >= beforecat.getCorder() && category.getCorder() < thiscat.getCorder())
                		category.setCorder(category.getCorder() + 1);
                }
            }            
            thiscat.setCorder(newo);
        }
        else
        {
        	int newo = 1;
            for(Category category : categories) {
            	if (category.getCorder() > thiscat.getCorder())
            		category.setCorder(category.getCorder() - 1);
            	newo = Math.max(newo, category.getCorder());
            }            
            thiscat.setCorder(newo + 1);
        }
		
	}
	
}
