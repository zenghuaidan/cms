package com.edeas.activiti;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.form.TaskFormData;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.activiti.engine.test.ActivitiRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ser.std.MapSerializer;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("/beans.xml")
@Transactional("txManager")
public class MyBusinessProcessTest extends AbstractTransactionalJUnit4SpringContextTests {

	@Autowired
	private RepositoryService repositoryService;

	@Autowired
	private RuntimeService runtimeService;

	@Autowired
	private TaskService taskService;
	
	@Autowired
	private HistoryService historyService;
	
	@Autowired
	private IdentityService identityService;
	
	@Autowired
	private FormService formService;

	@Autowired
	@Rule
	public ActivitiRule activitiSpringRule;

	@Test
	@Rollback(false)
//	@Before
	public void testDeleteProcessTest() {		
		List<ProcessDefinition> processDefinitions = repositoryService.createProcessDefinitionQuery().processDefinitionKey("VacationRequest").list();
		for(ProcessDefinition processDefinition : processDefinitions) {
			repositoryService.deleteDeployment(processDefinition.getDeploymentId(), true);					
		}
	}
	
	@Test
//	@Deployment(resources = { "VacationRequest.bpmn20.xml" })
	@Rollback(false)
	public void testProcessTest() {		
//		ProcessInstance processInstance = runtimeService.startProcessInstanceByKey("VacationRequest", variables);
		repositoryService.createDeployment().name("VacationRequest").addClasspathResource("VacationRequest.bpmn20.xml").deploy();
		
		ProcessInstance processInstance = null; 
		try {
			identityService.setAuthenticatedUserId("larry");
			Map<String, Object> variables = new HashMap<String, Object>();
			variables.put("requestor", "larry2");		
			processInstance = runtimeService.startProcessInstanceByKey("VacationRequest", variables);			
		} finally {
			identityService.setAuthenticatedUserId(null);
		}
		
		List<ProcessInstance> processInstances = runtimeService.createProcessInstanceQuery().processDefinitionId(processInstance.getProcessDefinitionId()).list();
		
		for(ProcessInstance _processInstance : processInstances) {
			System.out.println(_processInstance.getName());
		}
		
		
		List<Task> tasks = taskService.createTaskQuery().taskAssignee("larry").list();
		for(Task task : tasks) {
			System.out.println(task.getName());
			System.out.println("Initiator: " + runtimeService.getVariable(task.getExecutionId(), "initiator", String.class));
			System.out.println("Requestor: " + runtimeService.getVariable(task.getExecutionId(), "requestor", String.class));
			Map<String, String> properties = new HashMap<String, String>();
			properties.put("test1", "hello world");
			properties.put("test2", "123");
			properties.put("test3", "A");
			properties.put("test4", "01-01-2018");
			properties.put("test5", "true");
			//formService.submitTaskFormData(task.getId(), properties);
		}
		List<HistoricTaskInstance> historyTasks = historyService.createHistoricTaskInstanceQuery().processDefinitionId(processInstance.getProcessDefinitionId()).list();
		for(HistoricTaskInstance historyTask : historyTasks) {
			System.out.println(historyTask.getName());
//			TaskFormData taskFormData = formService.getTaskFormData(historyTask.getId());
//			List<FormProperty> formProperties = taskFormData.getFormProperties();			
//			for(FormProperty formProperty : formProperties) {			
//				System.out.println(formProperty.getId());
//				System.out.println(formProperty.getName());
//				System.out.println(formProperty.getValue());
//				System.out.println(formProperty.getClass());
//				System.out.println(formProperty.getType());
//			}
		}
		
//		Task myTask = taskService.createTaskQuery().taskAssignee("larry").singleResult();		
//		System.out.println(myTask.getName());
	}
}