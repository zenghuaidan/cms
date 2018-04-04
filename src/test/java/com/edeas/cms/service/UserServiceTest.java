package com.edeas.cms.service;

import static org.junit.Assert.assertEquals;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.test.ActivitiRule;
import org.hibernate.SessionFactory;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.dao.impl.UserDaoImpl;
import com.edeas.model.User;
import com.edeas.service.impl.UserServiceImpl;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("/beans.xml")
//------------如果加入以下代码，所有继承该类的测试类都会遵循该配置，也可以不加，在测试类的方法上///控制事务，参见下一个实例    
//这个非常关键，如果不加入这个注解配置，事务控制就会完全失效！    
@Transactional    
//这里的事务关联到配置文件中的事务控制器（transactionManager = "transactionManager"），同时//指定自动回滚（defaultRollback = true）。这样做操作的数据才不会污染数据库！    
//@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)    
@Rollback(true)
//------------  
public class UserServiceTest {

	@Autowired
	private RepositoryService repositoryService;

	@Autowired
	private RuntimeService runtimeService;

	@Autowired
	private TaskService taskService;

	@Autowired
	@Rule
	public ActivitiRule activitiSpringRule;
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	@Autowired
	private SessionFactory sessionFactory;

	@Test
//	@Deployment
	public void testProcessTest() {
		// runtimeService.startProcessInstanceByKey("simpleProcess");
		// Task task = taskService.createTaskQuery().singleResult();
		// assertEquals("My Task", task.getName());
		//
		// taskService.complete(task.getId());
		// assertEquals(0, runtimeService.createProcessInstanceQuery().count());

//		org.activiti.engine.repository.Deployment deployment = repositoryService.createDeployment()
//				.addClasspathResource("VacationRequest.bpmn20.xml").name("VacationRequest").deploy();
//
//		System.out.println(deployment.getId());
//		System.out.println(deployment.getName());
		User user = userServiceImpl.tryLogin("larry");
		assertEquals(user.getLogin(), "larry");
		
		sessionFactory.getCurrentSession().clear();
		String newPassword = User.getEncryptPassword("123456");
		System.out.println(newPassword);
		userServiceImpl.updatePassword("larry", "testing", "123456");
		user = userServiceImpl.tryLogin("larry");
		assertEquals(user.getPassword(), newPassword);
	}
}