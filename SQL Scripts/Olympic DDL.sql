/* ============================================================
                    OLYMPIC SQL ANALYSIS PROJECT
   ============================================================

   Author      : MD Nur Hossain Joy
   Database    : PostgreSQL

   Description:
   This script creates the Olympic dataset table.

   SQL Category: DDL (Data Definition Language)

   ============================================================ */


-- Create Olympic Table

CREATE TABLE public.olympic (

    id INT,
    name VARCHAR(255),
    sex VARCHAR(10),
    age INT,
    height NUMERIC,
    weight NUMERIC,
    team VARCHAR(255),
    noc VARCHAR(10),
    games VARCHAR(50),
    year INT,
    season VARCHAR(20),
    city VARCHAR(100),
    sport VARCHAR(100),
    event VARCHAR(255),
    medal VARCHAR(20)

);