package com.edeas.activiti;

import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;

public class MyTaskListener implements TaskListener {

	@Override
	public void notify(DelegateTask delegateTask) {
		System.out.println("yes");
		
	}

}
