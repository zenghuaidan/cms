package com.edeas.model;

import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.persistence.Transient;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name="CmsPage")
public class CmsPage extends Page<CmsPage, CmsContent> {
	private Long id;
	private Set<WorkflowMsg> workflowMsgs;
	
	@Id
	@GeneratedValue(strategy=GenerationType.TABLE,generator="pageTableGenerator")
	@TableGenerator(name="pageTableGenerator",initialValue=1,allocationSize=1) 
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@OneToMany(mappedBy="cmsPage")
	@OrderBy("id desc")
	public Set<WorkflowMsg> getWorkflowMsgs() {
		return workflowMsgs;
	}

	public void setWorkflowMsgs(Set<WorkflowMsg> workflowMsgs) {
		this.workflowMsgs = workflowMsgs;
	}
	
	@Transient
    public User getLatestPublishRequestor()
    {
		if(this.workflowMsgs == null || this.workflowMsgs.size() == 0)
			return null;
        for(WorkflowMsg workflowMsg : workflowMsgs) {
        	if(workflowMsg.isPublishRequest() && workflowMsg.getRelease() == this.getRelease())
        		return workflowMsg.getUser();
        }
        return null;
    }
}
