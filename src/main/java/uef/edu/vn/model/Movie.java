/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.ZoneId;
import org.springframework.format.annotation.DateTimeFormat;

/**
 *
 * @author baoni
 */
@Entity
@Table(name = "movies")
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Integer duration;
    
    @Column(length = 255)
    private String poster;
    
    private Double price;
    
    private String genre;
    
    @Column(name = "trailer_url")
    private String trailerUrl;

    @Column(name = "release_date")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate releaseDate;

    @Column(length = 20)
    private String status = "Sắp chiếu";


    public Movie() {
        this.id = 0L;
        this.name = "";
        this.description = "";
        this.duration = 0;
        this.poster = "";
        this.price = 0.0;
        this.genre = "";
        this.trailerUrl = "";
        this.releaseDate = null;
        this.status = "Sắp chiếu";
    }

    public Movie(String name, String description, Integer duration, String poster, Double price, String genre, String trailerUrl) {
        this.name = name;
        this.description = description;
        this.duration = duration;
        this.poster = poster;
        this.price = price;
        this.genre = genre;
        this.trailerUrl = trailerUrl;
    }

    public Movie(String name, String description, Integer duration,
            String poster, Double price, String genre,
            String trailerUrl, LocalDate releaseDate, String status) {
        this.name = name;
        this.description = description;
        this.duration = duration;
        this.poster = poster;
        this.price = price;
        this.genre = genre;
        this.trailerUrl = trailerUrl;
        this.releaseDate = releaseDate;
        this.status = status;
    
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster ) {
        this.poster = poster;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getTrailerUrl() {
        return trailerUrl;
    }

    public void setTrailerUrl(String trailerUrl) {
        this.trailerUrl = trailerUrl;
    }

    public LocalDate getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(LocalDate releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}