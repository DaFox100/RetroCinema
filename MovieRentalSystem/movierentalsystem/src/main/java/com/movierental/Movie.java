package com.movierental;

public class Movie {
    private int movie_id;
    private String title;
    private int total_copies;
    private int copies_rented;
    private String url;
    private String genre;
    private double price;
    private double rating;

    public Movie(int movie_id, String title, String genre, int total_copies, int copies_rented, double price, String url, double rating) {
        this.movie_id = movie_id;
        this.title = title;
        this.genre = genre;
        this.total_copies = total_copies;
        this.copies_rented = copies_rented;
        this.price = price;
        this.url = url;
        this.rating = rating;
        
    }

    public int getId() { return movie_id; }
    public String getTitle() { return title; }
    public String getGenre() { return genre; }
    public int getTotalCopies() { return total_copies; }
    public int getCopiesRented(){return copies_rented;}
    public double getPrice() { return price; }
    public String getUrl() { return url; }
    public double getRating() {return rating;}
    public String toString() {return "TITLE: "+title +" Rating: "+rating;}
}
