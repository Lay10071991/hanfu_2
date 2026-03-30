package com.example.demo.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "festival_activity_registration")
public class FestivalActivityRegistration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "festival_activity_id", nullable = false)
    private FestivalActivity festivalActivity;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(length = 20)
    private String status = "registered";

    @Column(name = "registration_time", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date registrationTime;

    public FestivalActivityRegistration() {
    }

    public FestivalActivityRegistration(FestivalActivity festivalActivity, Long userId) {
        this.festivalActivity = festivalActivity;
        this.userId = userId;
        this.status = "registered";
        this.registrationTime = new Date();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public FestivalActivity getFestivalActivity() {
        return festivalActivity;
    }

    public void setFestivalActivity(FestivalActivity festivalActivity) {
        this.festivalActivity = festivalActivity;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRegistrationTime() {
        return registrationTime;
    }

    public void setRegistrationTime(Date registrationTime) {
        this.registrationTime = registrationTime;
    }
}
