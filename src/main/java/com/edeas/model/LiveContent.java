package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

@Entity(name="LiveContent")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class LiveContent extends Content<LivePage> {
}
