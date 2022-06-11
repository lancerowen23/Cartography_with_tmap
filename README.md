# Elegant Cartography with tmap

As someone who works at the intersection of geospatial data science and public health, I have often encountered situations in which different parties come to the table with different technological fluencies. While proprietary and open-source GIS programs are the go-to for many GIS Analysts, those in the public health domain are more accustomed to using R or SAS to undertake their analysis. 

As part of an effort to expand R knowledge in my geospatial-oriented group, I helped deliver a series of demos aimed at showing the spatial and cartographic capabilities of R. This particular demo served to demonstrate how to create a choropleth map using R for a group of GIS Analysts who wanted to learn more about using R as an alternative to proprietary GIS platforms. A major focus of the code was specifying arguments to create a sophisiticated looking static map of publishable quality. I also stressed the importance of using JSON and GeoJSON files for geometry rather than the more cumbersome and less flexible shapefile format. The package of choice for the mapping is tmap.

![Mexico](Mex_COVID.png)
