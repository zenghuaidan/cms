package com.edeas.controller;

import javax.inject.Inject;

import org.activiti.engine.HistoryService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;

import com.edeas.service.impl.QueryServiceImpl;
import com.edeas.service.impl.UserServiceImpl;

public abstract class BaseController {
	// put all the service on the basic controller
	protected UserServiceImpl userService;	
	
	protected QueryServiceImpl queryService;
	
	protected RepositoryService repositoryService;
	
	protected RuntimeService runtimeService;
	
	protected TaskService taskService;
	
	protected HistoryService historyService;
	
	protected ManagementService managementService;
	
	protected ProcessEngine processEngine;
		
	@Inject
	public void setQueryService(QueryServiceImpl queryService) {
		this.queryService = queryService;
	}
	
	@Inject
	public void setUserService(UserServiceImpl userService) {
		this.userService = userService;
	}

	@Inject
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}

	@Inject
	public void setRuntimeService(RuntimeService runtimeService) {
		this.runtimeService = runtimeService;
	}

	@Inject
	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}

	@Inject
	public void setHistoryService(HistoryService historyService) {
		this.historyService = historyService;
	}

	@Inject
	public void setManagementService(ManagementService managementService) {
		this.managementService = managementService;
	}

	@Inject
	public void setProcessEngine(ProcessEngine processEngine) {
		this.processEngine = processEngine;
	}
	
}
