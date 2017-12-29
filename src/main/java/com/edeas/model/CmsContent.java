package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

@Entity(name="CmsContent")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class CmsContent extends Content<CmsPage> {
}
