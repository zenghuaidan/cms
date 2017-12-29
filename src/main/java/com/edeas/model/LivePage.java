package com.edeas.model;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

@Entity(name="LivePage")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class LivePage extends Page<LivePage, LiveContent> {
}
