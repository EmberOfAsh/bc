package com.zltel.broadcast.question.bean;

import java.util.Date;

public class Subject {
    private Integer subjectId;

    private String name;

    private String description;

    private Date addDate;

    private Date updateDate;

    public Subject(String name, String description) {
        this.name = name;
        this.description = description;
        this.addDate = this.updateDate = new Date();
    }

    public Subject(int id) {
        this.subjectId = id;
    }

    public Subject() {

    }

    public Integer getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(Integer subjectId) {
        this.subjectId = subjectId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

    public Date getAddDate() {
        return addDate;
    }

    public void setAddDate(Date addDate) {
        this.addDate = addDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }
}