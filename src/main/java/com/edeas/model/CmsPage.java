package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

@Entity(name="CmsPage")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class CmsPage extends Page<CmsPage, CmsContent> {

}
