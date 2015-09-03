<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : eventsXSL.xsl
    Created on : 24 giugno 2015, 11.07
    Author     : Anna Giulia
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
            <head>
                <link href="css/style.css" rel="stylesheet" type="text/css"/>
                <script src="https://maps.googleapis.com/maps/api/js"></script>
                <script src="javascript/maps.js" type="text/javascript"></script> 
                <script src="javascript/manageDetails.js" type="text/javascript"></script> 
                <script src="javascript/filter.js" type="text/javascript"></script>  
                <meta charset="UTF-8"></meta>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
                <title>Calendario eventi Romagna</title>
            </head>
            <body>
                <div id="container">
                    <a href="index.html">
                        <header id="title">
                            <img src="imgs/caveja.png" alt="Caveja"/>
                            <h1>Eventi in Romagna</h1>
                        </header>
                    </a>
                    <aside id="right">
                        <form method="GET" action="">
                            <div id="place-filter">
                            <h2>Dove andiamo?</h2>
                            <ul>
                                <li><input type="checkbox" name="district" value="FC">Forli-Cesena</input></li>
                                <li><input type="checkbox" name="district" value="RA">Ravenna</input></li>
                                <li><input type="checkbox" name="district" value="RN">Rimini</input></li>
                            </ul>
                            </div>
                            <div id="date-filter">
                                <h2>Quando andiamo?</h2>
                                <p>Dal <input type="date"/></p>
                                <p>Al <input type="date"/></p>
                            </div>        
                            <div id="do-filter">
                               <h2>Cosa facciamo?</h2>
                                <ul>
                                    <li><input type="checkbox" name="type" value="Concerto">Concerto</input></li>
                                    <li><input type="checkbox" name="type" value="Conferenza">Conferenza</input></li>
                                    <li><input type="checkbox" name="type" value="Fiera">Fiera</input></li>
                                    <li><input type="checkbox" name="type" value="Mostra">Mostra</input></li>
                                    <li><input type="checkbox" name="type" value="Sagra">Sagra</input></li>
                                    <li><input type="checkbox" name="type" value="Spettacolo">Spettacolo</input></li> 
                                </ul> 
                            </div>
                            <input type="submit" value="Applica filtri" id="apply"/>
                        </form>
                        <a href="" id="noFilter" onclick="location.reload(true);">Elimina filtri</a>
                    </aside>


                    <div id="left">
                        <nav id="menu">
                            <a id="date-sort" href="eventsDateDesc.html">Ordina per data</a>
                            <a id="groupby-city" href="groupByCity.html">Raggruppa per citta</a>
                            <a id="groupby-type" href="groupByType.html">Raggruppa per tipo</a>
                        </nav>
                        <section>
                            <xsl:for-each select="event-list/event">
                                <xsl:sort select="period/start/date/year" order="ascending"/>
                                <xsl:sort select="period/start/date/month" order="ascending"/>
                                <xsl:sort select="period/start/date/day" order="ascending"/>
                                <article>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="location/district"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="type"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@id"/>
                                        <xsl:text>_</xsl:text>
                                        <xsl:value-of select="period/start/date/year"/>
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="period/start/date/month"/>
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="period/start/date/day"/>
                                        <xsl:text>_</xsl:text>
                                        <xsl:value-of select="period/end/date/year"/>
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="period/end/date/month"/>
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="period/end/date/day"/>
                                    </xsl:attribute>
                                    <div class="image">
                                        <img>
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="image"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="image"/>
                                            </xsl:attribute>
                                        </img>
                                    </div>
                                    <div class="info-event">
                                        <h3><xsl:value-of select="title"/></h3>
                                        <p class="type"><xsl:value-of select="type"/></p>
                                        <p class="date">
                                            <span class="date-start">
                                                <xsl:value-of select="period/start/date/day"/>/<xsl:value-of select="period/start/date/month"/>/<xsl:value-of select="period/start/date/year"/>
                                            </span>
                                            <span class="date-end"> - 
                                                <xsl:value-of select="period/end/date/day"/>/<xsl:value-of select="period/end/date/month"/>/<xsl:value-of select="period/end/date/year"/>
                                            </span>
                                        </p>
                                        <p class="place">
                                            <xsl:value-of select="location/city"/>  
                                            (<xsl:value-of select="location/district"/>)
                                        </p>
                                    </div>
                                    
                                    <xsl:variable name="idShowDetail" select="concat('showDetail',@id)"></xsl:variable>
                                    <xsl:variable name="idDetail" select="concat('detail',@id)"></xsl:variable>
                                    <xsl:variable name="idHideDetail" select="concat('hideDetail',@id)"></xsl:variable>
                                    <xsl:variable name="lat" select="location/map/lat"></xsl:variable>
                                    <xsl:variable name="long" select="location/map/long"></xsl:variable>
                                    <xsl:variable name="idMap" select="concat('map',@id)"></xsl:variable>
                                    
                                    <a class="show-detail" onclick="manageDetail('{$idDetail}','{$idShowDetail}'); initialize('{$lat}','{$long}','{$idMap}');">
                                        <xsl:attribute name="id"><xsl:value-of select="concat('showDetail',@id)"/></xsl:attribute>
                                        Visualizza dettagli
                                    </a>
                                    <div class="details-event">
                                        <xsl:attribute name="id"><xsl:value-of select="concat('detail',@id)"/></xsl:attribute>
                                        <div class="map">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('map',@id)"/></xsl:attribute>
                                        </div>
                                        <p>
                                            <span class="bold">Ora di inizio: </span> 
                                            <xsl:value-of select="period/start/time/hour"/>:<xsl:value-of select="period/start/time/minute"/>
                                        </p>
                                        <p>
                                            <span class="bold">Indirizzo: </span>
                                            <xsl:value-of select="location/address"/>, <xsl:value-of select="location/number"/> 
                                        </p>
                                        <p><xsl:value-of select="description"/></p>
                                        
                                        <a class="webSite">
                                            <xsl:attribute name="href"><xsl:value-of select="webSite"/></xsl:attribute>
                                            Visita il sito web
                                        </a>
                                        
                                        <a class="hide-detail" onclick="manageDetail('{$idShowDetail}','{$idDetail}')">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('hideDetail',@id)"/></xsl:attribute>
                                            Nascondi dettagli
                                        </a>
                                    </div>
                                </article>
                            </xsl:for-each>           
                        </section>
                    </div>
                </div>    
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
