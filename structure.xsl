<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:php="http://php.net/xsl"
                xsl:extension-element-prefixes="php">
    <xsl:output method="html" indent="yes" />
    <xsl:template match="/">
            <div>
                <h3>Namespaces</h3>
                <ul>
                    <xsl:for-each select="//namespace" >
                        <xsl:variable name="namespace" select="@full_name" />
                        <xsl:variable name="interfaceCount" select="count(/project/file/interface[@namespace=$namespace])" />
                        <xsl:variable name="classCount" select="count(/project/file/class[@namespace=$namespace])" />
                        <xsl:variable name="traitCount" select="count(/project/file/trait[@namespace=$namespace])" />

                        <xsl:if test="$interfaceCount &gt; 0 or $classCount &gt; 0 or $traitCount &gt; 0">
                            <li>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat('#namespace_', translate($namespace, '\', '_'))" />
                                    </xsl:attribute>
                                    <xsl:value-of select="$namespace" />
                                </xsl:element>
                            </li>
                        </xsl:if>
                    </xsl:for-each>
                </ul>
            </div>
            <xsl:for-each select="//namespace" >
                <xsl:variable name="namespace" select="@full_name" />
                <xsl:variable name="interfaceCount" select="count(/project/file/interface[@namespace=$namespace])" />
                <xsl:variable name="classCount" select="count(/project/file/class[@namespace=$namespace])" />
                <xsl:variable name="traitCount" select="count(/project/file/trait[@namespace=$namespace])" />

                <xsl:if test="$interfaceCount &gt; 0 or $classCount &gt; 0 or $traitCount &gt; 0">
                    <div>
                        <xsl:element name="a">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('namespace_', translate($namespace, '\', '_'))" />
                            </xsl:attribute>
                        </xsl:element>
                        <h3><xsl:value-of select="$namespace" /></h3>
                        <dl>
                            <xsl:if test="$interfaceCount &gt; 0">
                                <dt>Interfaces</dt>
                                <dd>
                                    <ul>
                                        <xsl:for-each select="/project/file/interface[@namespace=$namespace]">
                                            <li>
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#interface_', translate(full_name, '\', '_'))" />
                                                    </xsl:attribute>
                                                    <xsl:value-of select="name" />
                                                </xsl:element>
                                                <p><xsl:value-of select="docblock/description"/></p>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </dd>
                            </xsl:if>
                            <xsl:if test="$classCount &gt; 0">
                                <dt>Classes</dt>
                                <dd>
                                    <ul>
                                        <xsl:for-each select="/project/file/class[@namespace=$namespace]">
                                            <li>
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#class_', translate(full_name, '\', '_'))" />
                                                    </xsl:attribute>
                                                    <xsl:value-of select="name" />
                                                </xsl:element>
                                                <p><xsl:value-of select="docblock/description"/></p>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </dd>
                            </xsl:if>
                            <xsl:if test="$traitCount &gt; 0">
                                <dt>Traits</dt>
                                <dd>
                                    <ul>
                                        <xsl:for-each select="/project/file/trait[@namespace=$namespace]">
                                            <li>
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#trait_', translate(full_name, '\', '_'))" />
                                                    </xsl:attribute>
                                                    <xsl:value-of select="name" />
                                                </xsl:element>
                                                <p><xsl:value-of select="docblock/description"/></p>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </dd>
                            </xsl:if>
                        </dl>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="/project/file/interface" >
                <xsl:variable name="constantCount" select="count(constant)" />
                <xsl:variable name="methodCount" select="count(method)" />
                <div>
                    <xsl:element name="a">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('interface_', translate(full_name, '\', '_'))" />
                        </xsl:attribute>
                    </xsl:element>
                    <h3><xsl:value-of select="full_name" /></h3>
                    <p><xsl:value-of select="description" /></p>
                    <xsl:if test="$constantCount &gt; 0">
                        <div>
                            <h4>Constants</h4>
                            <dl>
                                <xsl:for-each select="constant">
                                    <dt><pre><xsl:value-of select="name" /> = <xsl:value-of select="value" /></pre></dt>
                                    <dd><xsl:value-of select='docblock/description' /></dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                    <xsl:if test="$methodCount &gt; 0">
                        <div>
                            <h4>Methods</h4>
                            <dl>
                                <xsl:for-each select="method">
                                    <dt><pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre></dt>
                                    <dd>
                                        <p><xsl:value-of select="docblock/description" /></p>
                                        <div>
                                            <div>
                                                <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::decode', docblock/long-description)" disable-output-escaping="yes" /></p>
                                            </div>
                                            <xsl:if test="count(docblock/tag[@name='param']) &gt; 0">
                                                <h5>Parameters</h5>
                                                <xsl:for-each select="docblock/tag[@name='param']">
                                                    <div>
                                                        <h4><xsl:value-of select="@variable" /></h4>
                                                        <code><xsl:value-of select="@type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='return']) &gt; 0">
                                                <h5>Returns</h5>
                                                <xsl:for-each select="docblock/tag[@name='return']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='throws']) &gt; 0">
                                                <h5>Exceptions</h5>
                                                <xsl:for-each select="docblock/tag[@name='throws']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </div>
                                    </dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                </div>
            </xsl:for-each>
            <xsl:for-each select="//class" >
                <xsl:variable name="constantCount" select="count(constant)" />
                <xsl:variable name="propertyCount" select="count(property)" />
                <xsl:variable name="methodCount" select="count(method)" />
                <div>
                    <xsl:element name="a">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('class_', translate(full_name, '\', '_'))" />
                        </xsl:attribute>
                    </xsl:element>
                    <h3><xsl:value-of select="full_name" /></h3>
                    <p><xsl:value-of select="description" /></p>
                    <xsl:if test="$constantCount &gt; 0">
                        <div>
                            <h4>Constants</h4>
                            <dl>
                                <xsl:for-each select="constant">
                                    <dt><pre><xsl:value-of select="name" /> = <xsl:value-of select="value" /></pre></dt>
                                    <dd><xsl:value-of select='docblock/description' /></dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                    <xsl:if test="$propertyCount &gt; 0">
                        <div>
                            <h4>Properties</h4>
                            <dl>
                                <xsl:for-each select="property">
                                    <dt><pre><xsl:value-of select="name" /></pre></dt>
                                    <dd><xsl:value-of select='docblock/description' /></dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                    <xsl:if test="$methodCount &gt; 0">
                        <div>
                            <h4>Methods</h4>
                            <dl>
                                <xsl:for-each select="method">
                                    <dt><pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre></dt>
                                    <dd>
                                        <p><xsl:value-of select="docblock/description" /></p>
                                        <div>
                                            <div>
                                                <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::decode', docblock/long-description)" disable-output-escaping="yes" /></p>
                                            </div>
                                            <xsl:if test="count(docblock/tag[@name='param']) &gt; 0">
                                                <h5>Parameters</h5>
                                                <xsl:for-each select="docblock/tag[@name='param']">
                                                    <div>
                                                        <h4><xsl:value-of select="@variable" /></h4>
                                                        <code><xsl:value-of select="@type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='return']) &gt; 0">
                                                <h5>Returns</h5>
                                                <xsl:for-each select="docblock/tag[@name='return']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='throws']) &gt; 0">
                                                <h5>Exceptions</h5>
                                                <xsl:for-each select="docblock/tag[@name='throws']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </div>
                                    </dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                </div>
            </xsl:for-each>
            <xsl:for-each select="//trait" >
                <xsl:variable name="methodCount" select="count(method)" />
                <div>
                    <xsl:element name="a">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('trait_', translate(full_name, '\', '_'))" />
                        </xsl:attribute>
                    </xsl:element>
                    <h3><xsl:value-of select="full_name" /></h3>
                    <p><xsl:value-of select="description" /></p>
                    <xsl:if test="$methodCount &gt; 0">
                        <div>
                            <h4>Methods</h4>
                            <dl>
                                <xsl:for-each select="method">
                                    <dt><pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre></dt>
                                    <dd>
                                        <p><xsl:value-of select="docblock/description" /></p>
                                        <div>
                                            <div>
                                                <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::decode', docblock/long-description)" disable-output-escaping="yes" /></p>
                                            </div>
                                            <xsl:if test="count(docblock/tag[@name='param']) &gt; 0">
                                                <h5>Parameters</h5>
                                                <xsl:for-each select="docblock/tag[@name='param']">
                                                    <div>
                                                        <h4><xsl:value-of select="@variable" /></h4>
                                                        <code><xsl:value-of select="@type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='return']) &gt; 0">
                                                <h5>Returns</h5>
                                                <xsl:for-each select="docblock/tag[@name='return']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="count(docblock/tag[@name='throws']) &gt; 0">
                                                <h5>Exceptions</h5>
                                                <xsl:for-each select="docblock/tag[@name='throws']">
                                                    <div>
                                                        <code><xsl:value-of select="type" /></code>
                                                        <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></p>
                                                    </div>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </div>
                                    </dd>
                                </xsl:for-each>
                            </dl>
                        </div>
                    </xsl:if>
                </div>
            </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
