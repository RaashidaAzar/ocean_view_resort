package com.oceanview.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Reservation {
    private int id;
    private String reservationNumber;
    private String guestName;
    private String address;
    private String nicNumber;
    private String contactNumber;
    private String roomCategory;
    private String roomType;
    private String mealPlan;
    private Date checkInDate;
    private Date checkOutDate;
    private int numAdults;
    private int numChildren;
    private int numRooms;
    private String promoCode;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;

    public Reservation() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getNicNumber() { return nicNumber; }
    public void setNicNumber(String nicNumber) { this.nicNumber = nicNumber; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getRoomCategory() { return roomCategory; }
    public void setRoomCategory(String roomCategory) { this.roomCategory = roomCategory; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getMealPlan() { return mealPlan; }
    public void setMealPlan(String mealPlan) { this.mealPlan = mealPlan; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getNumAdults() { return numAdults; }
    public void setNumAdults(int numAdults) { this.numAdults = numAdults; }

    public int getNumChildren() { return numChildren; }
    public void setNumChildren(int numChildren) { this.numChildren = numChildren; }

    public int getNumRooms() { return numRooms; }
    public void setNumRooms(int numRooms) { this.numRooms = numRooms; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
