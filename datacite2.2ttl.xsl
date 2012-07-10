<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    
    xmlns="http://datacite.org/schema/kernel-2.2"
    xmlns:d="http://datacite.org/schema/kernel-2.2"
    
    version="1.0" >
    
    <!-- 
    
    author:             Tanya Gray
    email:              tanya.gray@zoo.ox.ac.uk
    date-created:       10th July 2012
    purpose:            transformation of DataCite metadata record (version 2.2) 
                        as exemplied in datacite-metadata-sample-v2.2.xml 
                        to RDF turtle, defined in DataCiteMetadata2.2_mapping_to_RDF_09-07-2012.doc
                        and exemplified in RDF_mapping_of_DataCitev2.2_XML_example.ttl
    version:            0.1
    version-history:    0.1: first draft
    
    
    -->
   
    <xsl:output method="text"
        
        encoding="UTF-8"
        omit-xml-declaration="yes"
        indent="no"
        media-type="text/plain"  />
    <xsl:template match="/">
        <xsl:text><![CDATA[@prefix cito: <http://purl.org/spar/cito/> .
@prefix datacite: <http://purl.org/spar/datacite/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcmitype: <http://purl.org/dc/dcmitype/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix fabio: <http://purl.org/spar/fabio/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix frapo: <http://purl.org/cerif/frapo/> .
@prefix frbr: <http://purl.org/spar/frbr/> .
@prefix literal: <http://www.essepuntato.it/2010/06/literalreification/> .
@prefix prism: <http://prismstandard.org/namespaces/basic/2.0/> .
@prefix pro: <http://purl.org/spar/pro/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/TR/2004/REC-rdf-schema-20040210/> .
@prefix scoro: <http://purl.org/spar/scoro/> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .]]>
        
        </xsl:text>
        
<xsl:apply-templates mode="resource" select="."/>    
    </xsl:template>
    
 <xsl:template mode="resource" match="*" >
     
 <xsl:value-of select="concat('&lt;http://dx.doi.org/',d:identifier[@identifierType = 'DOI']/text(), '&gt;')"/>
        rdf:type fabio:Dataset ;
        datacite:hasIdentifier [ rdf:type datacite:PrimaryResourceIdentifier ;
        literal:hasLiteralValue "<xsl:value-of select="d:identifier[@identifierType = 'DOI']/text()"/>" ;
        datacite:usesIdentifierScheme datacite:doi ] ;
        <xsl:for-each select="d:creators/d:creator">
        dcterms:creator [rdf:type foaf:Person ; foaf:name "<xsl:value-of select="d:creatorName"/> ] ;               
<xsl:for-each select="d:nameIdentifier">
    datacite:hasIdentifier  
[rdf:type datacite:PersonalIdentifier ;
            literal:hasLiteralValue "<xsl:value-of select="text()"/> ;
            datacite:usesIdentifierScheme datacite:<xsl:value-of select="@nameIdentifierScheme"/> ] ] ;      
            </xsl:for-each></xsl:for-each>
dcterms:title "<xsl:value-of select="d:titles/d:title[1]"/>" ;
     fabio:hasSubtitle "<xsl:value-of select="d:titles/d:title[@titleType='Subtitle']"/>" ;
        dc:publisher " <xsl:value-of select="d:publisher"/>" ;
        fabio:hasPublicationYear "<xsl:value-of select="d:publicationYear"/>" ;
     <xsl:for-each select="d:subjects/d:subject">
         <xsl:choose>
             <xsl:when test="boolean(./@subjectScheme='DDC')">
                 skos:inScheme [ rdf:type fabio:TermDictionary ; 
                 rdf:label "Dewey Decimal Classification Scheme: <xsl:value-of select="."/>" ;
                 
             </xsl:when>
             <xsl:otherwise>
                 dcterms:subject [ rdf:label "<xsl:value-of select="."/>" ;
             </xsl:otherwise>
         </xsl:choose>
        
     </xsl:for-each>
     foaf:homepage &lt;http://dewey.info/class/551/2009-08/about.en&gt; ] ] ;
     <xsl:for-each select="d:contributors/d:contributor">
         <xsl:choose>
             <xsl:when test="@contributorType = 'DataManager'">
                 dcterms:contributor  [ rdf:type foaf:Organization ; foaf:name "<xsl:value-of select="d:contributorName"/>" ;
                 foaf:homepage   ;
                 pro:holdsRoleInTime [ pro:withRole pro:data-manager ] ] ;
             </xsl:when>
             <xsl:when test="@contributorType = 'ContactPerson'">
                 dcterms:contributor [rdf:type foaf:Person ; foaf:name "<xsl:value-of select="d:contributorName"/>" ; # Note: fictitious name
                 
                  <xsl:for-each select="d:nameIdentifier">
                 datacite:hasIdentifier 
                 [rdf:type datacite:PersonalIdentifier ;
                 literal:hasLiteralValue "<xsl:value-of select="."/>" ; 
                      <xsl:choose>
                          <xsl:when test="@nameIdentifierScheme ='ORCID'">
                              datacite:usesIdentifierScheme datacite:orcid ] ;
                          </xsl:when>
                      </xsl:choose>
 pro:holdsRoleInTime [ pro:withRole scoro:contact-person ] ] ;
                  </xsl:for-each>   
             </xsl:when>
             <xsl:otherwise></xsl:otherwise>
         </xsl:choose>
     </xsl:for-each>
     <xsl:for-each select="d:dates/d:date">
         <xsl:choose>
             <xsl:when test="@dateType = 'Valid'">
                 dcterms:valid "<xsl:value-of select="."/>"^^xsd:date ; 
             </xsl:when>
             <xsl:when test="@dateType = 'Accepted'">
                 dcterms:dateAccepted "<xsl:value-of select="."/>^^xsd:date ; 
             </xsl:when>
             <xsl:otherwise/>
         </xsl:choose>
         
     </xsl:for-each>
dcterms:language &lt;http://lexvo.org/id/iso639-3/<xsl:value-of select="d:language"/>&gt; ;  
     dcterms:type [ literal:hasLiteralValue "<xsl:value-of select="d:resourceType"/>" ; datacite:hasGeneralResourceType dcmitype:<xsl:value-of select="@resourceTypeGeneral"/> ] ;
                <xsl:for-each select="d:alternateIdentifiers/d:alternateIdentifier">
                    
                    datacite:hasIdentifier 
                    [rdf:type datacite:AlternateResourceIdentifier ;
                    literal:hasLiteralValue "<xsl:value-of select="."/>" ;
                    <xsl:choose>
                        <xsl:when test="@alternateIdentifierType = 'ISBN'">
                            datacite:usesIdentifierScheme datacite:isbn ] ;
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:for-each>
                
  
     <xsl:for-each select="d:relatedIdentifiers/d:relatedIdentifier">
         <xsl:choose>
             <xsl:when test="@relationType = 'isCitedBy'">
                 cito:isCitedBy [ datacite:hasIdentifer 
                 [rdf:type datacite:ResourceIdentifier ; literal:hasLiteralValue "<xsl:value-of select='.'/>" ;  
                 <xsl:choose>
                     
                 
                 <xsl:when test="@relatedIdentifierType = 'DOI'">
                 datacite:usesIdentifierScheme datacite:doi ] ] ;
                 </xsl:when>
                     <xsl:when test="@relatedIdentifierType = 'URN'">
                         datacite:usesIdentifierScheme datacite:urn ] ] ;
                     </xsl:when>
                 </xsl:choose>
             </xsl:when>
             <xsl:when test="relationType = 'Cites'">
                 cito:cites [ datacite:hasIdentifer 
                 [rdf:type datacite:ResourceIdentifier ; 
                 literal:hasLiteralValue "<xsl:value-of select="."/>" ;
                 
                 <xsl:choose>
                     
                     <xsl:when test="@relatedIdentifierType = 'DOI'">
                         datacite:usesIdentifierScheme datacite:doi ] ] ;
                     </xsl:when>
                     <xsl:when test="@relatedIdentifierType = 'URN'">
                         datacite:usesIdentifierScheme datacite:urn ] ] ;
                     </xsl:when>
                 </xsl:choose>
                 
             </xsl:when>
         </xsl:choose>
         
     </xsl:for-each>
 <xsl:for-each select="d:sizes/d:size">
                   dcterms:extent [ rdf:type dcterms:SizeOrDuration ; dcterms:description "<xsl:value-of select='.'/>" ] ;
               </xsl:for-each>
 <xsl:for-each select="d:formats/d:format">
                    dcterms:format [ rdf:type dcterms:MediaTypeOrExtent ; dcterms:description "<xsl:value-of select='.'/>" ] ;         
                </xsl:for-each>      
                prism:versionIdentifier "<xsl:value-of select="d:version"/>" ;
                dc:rights "<xsl:value-of select="d:rights"/>" ;
                dcterms:rights &lt;http://www.opendatacommons.org/licenses/odbl/1-0/&gt; .
                
 &lt;http://test.datacite.org/schema/meta/kernel-2.2/example/datacite-metadata-sample-v2.2.xml&gt; 
                    dc:subject "DataCite Metadata Schema V 2.2" ;
                    prism:publicationDate "2011-07-17" ;
     <xsl:for-each select="d:descriptions/d:description[@descriptionType='Other']">
                    datacite:hasDescription [ datacite:hasDescriptionType datacite:other ; 
                    literal:hasLiteralValue "<xsl:value-of select="text()"/>" ] .
          
                        
                    </xsl:for-each>    
     
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
</xsl:stylesheet>