package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name="CmsContent", uniqueConstraints = {@UniqueConstraint(columnNames={"pageId", "lang"})})
public class CmsContent extends Content<CmsPage> {
}
