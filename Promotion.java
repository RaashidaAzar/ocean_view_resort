package com.oceanview.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Promotion {
    private int id;
    private String promoCode;
    private String description;
    private BigDecimal discountPercentage;
    private Date startDate;
    private Date endDate;
    private boolean isActive;

    public Promotion() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(BigDecimal discountPercentage) { this.discountPercentage = discountPercentage; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
