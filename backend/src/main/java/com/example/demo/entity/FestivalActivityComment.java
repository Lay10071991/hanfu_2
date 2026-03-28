package com.example.demo.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "festival_activity_comment")
public class FestivalActivityComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "activity_id", nullable = false)
    private FestivalActivity activity;

    @Column(name = "user_name", nullable = false, length = 50)
    private String userName;

    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;

    @Column(name = "create_time", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createTime;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public FestivalActivity getActivity() {
        return activity;
    }

    public void setActivity(FestivalActivity activity) {
        this.activity = activity;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    // Constructor
    public FestivalActivityComment() {
    }

    public FestivalActivityComment(FestivalActivity activity, String userName, String content) {
        this.activity = activity;
        this.userName = userName;
        this.content = content;
        this.createTime = new Date();
    }
}