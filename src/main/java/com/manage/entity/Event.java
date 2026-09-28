package com.manage.entity;

public class Event {
    private String event_id, organizer_id, title, image, desc, create_type;

    public Event() {}

    public Event(String event_id, String organizer_id, String title, String image, String desc, String create_type) {
        this.event_id = event_id;
        this.organizer_id = organizer_id;
        this.title = title;
        this.image = image;
        this.desc = desc;
        this.create_type = create_type;
    }

    public String getEvent_id() {
        return event_id;
    }

    public void setEvent_id(String event_id) {
        this.event_id = event_id;
    }

    public String getOrganizer_id() {
        return organizer_id;
    }

    public void setOrganizer_id(String organizer_id) {
        this.organizer_id = organizer_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getCreate_type() {
        return create_type;
    }

    public void setCreate_type(String create_type) {
        this.create_type = create_type;
    }
}

