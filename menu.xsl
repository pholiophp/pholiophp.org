<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:php="http://php.net/xsl"
                xsl:extension-element-prefixes="php">
    <xsl:output method="html" indent="yes" />
    <xsl:template match="/">
        <xsl:for-each select="//namespace" >
            <xsl:variable name="namespace" select="@full_name" />
            <xsl:variable name="interfaceCount" select="count(/project/file/interface[@namespace=$namespace])" />
            <xsl:variable name="classCount" select="count(/project/file/class[@namespace=$namespace])" />
            <xsl:variable name="traitCount" select="count(/project/file/trait[@namespace=$namespace])" />
            <xsl:if test="$interfaceCount &gt; 0 or $classCount &gt; 0 or $traitCount &gt; 0">
                <xsl:variable name="namespaceId" select="concat('collapse', translate($namespace, '\', '_'))" />
                <div class="panel-group">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat('#', $namespaceId)" />
                                    </xsl:attribute>
                                    <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                    <xsl:value-of select="$namespace" />
                                </xsl:element>
                            </h4>
                        </div>
                        <xsl:element name="div">
                            <xsl:attribute name="id"><xsl:value-of select="$namespaceId" /></xsl:attribute>
                            <xsl:attribute name="class">panel-collapse collapse</xsl:attribute>
                            <ul class="list-group">
                                <xsl:for-each select="/project/file/interface[@namespace=$namespace]">
                                    <li class="list-group-item">
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('#', translate(full_name, '\', '_'))" />
                                            </xsl:attribute>
                                            <xsl:value-of select="name" />
                                        </xsl:element>
                                    </li>
                                </xsl:for-each>
                                <xsl:for-each select="/project/file/class[@namespace=$namespace]">
                                    <li class="list-group-item">
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('#', translate(full_name, '\', '_'))" />
                                            </xsl:attribute>
                                            <xsl:value-of select="name" />
                                        </xsl:element>
                                    </li>
                                </xsl:for-each>
                                <xsl:for-each select="/project/file/trait[@namespace=$namespace]">
                                    <li class="list-group-item">
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('#', translate(full_name, '\', '_'))" />
                                            </xsl:attribute>
                                            <xsl:value-of select="name" />
                                        </xsl:element>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:element>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
