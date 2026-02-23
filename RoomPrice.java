package com.oceanview.model;

import java.math.BigDecimal;

public class RoomPrice {
    private int id;
    private String roomCategory;
    private String roomType;
    private String mealPlan;
    private BigDecimal pricePerNight;

    public RoomPrice() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomCategory() { return roomCategory; }
    public void setRoomCategory(String roomCategory) { this.roomCategory = roomCategory; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getMealPlan() { return mealPlan; }
    public void setMealPlan(String mealPlan) { this.mealPlan = mealPlan; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }
}
