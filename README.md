# Ngojek App - Ride Estimation & Payment System

Ngojek is a mobile app that provides users with the ability to estimate the cost of rides between an origin and a destination, along with displaying the distance traveled. The app also integrates a payment system for users to pay for their rides in different currencies, including Rupiah, USD, and Ringgit.

## Features:

- **Google Map Integration:** Users can select both origin and destination on an interactive map.
- **Real-Time Distance Calculation:** The app calculates the real-time distance between the origin and destination and provides an estimated cost based on the distance.
- **Multiple Currency Support:** Estimated costs are displayed in **Indonesian Rupiah (IDR)**, **US Dollars (USD)**, and **Malaysian Ringgit (MYR)**.
- **Polyline Display:** The app uses Google Maps Polyline to visually display the route between the selected locations.
- **Payment Integration:** Once the user confirms the estimate, the app allows payment using the displayed cost in multiple currencies.

## Tech Stack:
- **Flutter:** Cross-platform development framework.
- **Google Maps SDK:** For map and location-related features.
- **Hive:** Local storage for user data and payment records.
- **Intl Package:** For currency formatting and number formatting.

## How to Use:
1. Open the app and select the origin and destination by long-pressing on the map.
2. The app will estimate the distance and display the cost in various currencies.
3. Once the details are confirmed, click the "Order" button to proceed with the payment.
4. Payment details can be tracked and accessed in the "Orders" section.
