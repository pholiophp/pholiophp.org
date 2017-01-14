<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:php="http://php.net/xsl"
                xsl:extension-element-prefixes="php">
    <xsl:output method="html" indent="yes" />
    <xsl:template match="/">
        <!-- interfaces -->
        <xsl:for-each select="/project/file/interface" >
            <xsl:variable name="constantCount" select="count(constant)" />
            <xsl:variable name="methodCount" select="count(method)" />
            <xsl:variable name="interfaceId" select="concat('', translate(full_name, '\', '_'))" />
            <xsl:variable name="constantsId" select="concat('constants_', translate(full_name, '\', '_'))" />
            <xsl:variable name="methodsId" select="concat('methods_', translate(full_name, '\', '_'))" />
            <xsl:element name="div">
                <xsl:attribute name="class">accordion</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="$interfaceId" /></xsl:attribute>
                <div class="accordion-group">
                    <xsl:element name="div">
                        <xsl:attribute name="class">accordion-heading</xsl:attribute>
                        <xsl:element name="a">
                            <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                            <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                            <xsl:attribute name="data-parent"><xsl:value-of select="concat('#', $interfaceId)" /></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('#collapse', $interfaceId)" /></xsl:attribute>
                            <h2><xsl:value-of select="full_name" /></h2>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id"><xsl:value-of select="concat('collapse', $interfaceId)" /></xsl:attribute>
                        <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                        <div class="accordion-inner">
                            <!-- Here we insert another nested accordion -->
                            <xsl:element name="div">
                                <xsl:attribute name="id"><xsl:value-of select="concat('accordian', $interfaceId)" /></xsl:attribute>
                                <xsl:attribute name="class">accordion</xsl:attribute>

                                <xsl:variable name="hasExtends">
                                    <xsl:for-each select="extends">
                                        <xsl:if test=". != ''">
                                            <xsl:value-of select="." />
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="$hasExtends != ''">
                                    <h3>Extends</h3>
                                    <xsl:for-each select="extends">
                                        <xsl:if test=". != ''">
                                           <xsl:element name="a">
                                               <xsl:attribute name="href">
                                                   <xsl:value-of select="concat('#', translate(., '\', '_'))" />
                                               </xsl:attribute>
                                               <code><xsl:value-of select="." /></code>
                                           </xsl:element>
                                           <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>

                                <xsl:if test="$constantCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $interfaceId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseConstants', $interfaceId)" /></xsl:attribute>
                                                <h3>Constants</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseConstants', $interfaceId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <xsl:for-each select="constant">
                                                    <div class="row">
                                                        <div class="col-md-12 pull-left">
                                                            <h4><xsl:value-of select="../name" />::<xsl:value-of select="name" /></h4>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <p><xsl:value-of select="docblock/description" /></p>
                                                            <table class="table">
                                                                <xsl:for-each select="docblock/tag">
                                                                    <tr>
                                                                        <td>
                                                                            <strong><xsl:value-of select="@name" /></strong>
                                                                        </td>
                                                                        <td>
                                                                            <xsl:value-of select="@description" />
                                                                        </td>
                                                                    </tr>
                                                                </xsl:for-each>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>

                                <xsl:if test="$methodCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $interfaceId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseMethods', $interfaceId)" /></xsl:attribute>
                                                <h3>Methods</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseMethods', $interfaceId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <xsl:for-each select="method">
                                                    <div class="row">
                                                        <div class="col-md-12 pull-left">
                                                            <h4><xsl:value-of select="../name" />::<xsl:value-of select="name" />()</h4>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', docblock/description)" /></p>
                                                            <pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre>
                                                            <xsl:variable name="parameterCount" select="count(docblock/tag[@name='param'])" />
                                                            <xsl:if test="$parameterCount &gt; 0">
                                                                <h5>Parameters</h5>
                                                                <table class="table table-bordered">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Name</th>
                                                                            <th>Type</th>
                                                                            <th>Description</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <xsl:for-each select="docblock/tag[@name='param']">
                                                                            <tr>
                                                                                <td><xsl:value-of select="@variable" /></td>
                                                                                <td><code><xsl:value-of select="@type" /></code></td>
                                                                                <td><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></td>
                                                                            </tr>
                                                                        </xsl:for-each>
                                                                    </tbody>
                                                                </table>
                                                            </xsl:if>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <h5>Return Value</h5>
                                                            <xsl:choose>
                                                                <xsl:when test="docblock/tag[@name='return']/type != 'void'">
                                                                    <code><xsl:value-of select="docblock/tag[@name='return']/@type" /></code>
                                                                    <p><xsl:value-of select="docblock/tag[@name='return']/@description" /></p>
                                                                </xsl:when>
                                                                <xsl:otherwise>void</xsl:otherwise>
                                                            </xsl:choose>
                                                        </div>
                                                        <xsl:variable name="exceptionCount" select="count(docblock/tag[@name='throws'])" />
                                                        <xsl:if test="$exceptionCount &gt; 0">
                                                            <div class="col-md-11 col-md-offset-1">
                                                                <h5>Exceptions</h5>
                                                                <table class="table">
                                                                    <xsl:for-each select="docblock/tag[@name='throws']">
                                                                         <tr>
                                                                            <td><code><xsl:value-of select="@type" /></code></td>
                                                                            <td><xsl:value-of select="@description" /></td>
                                                                         </tr>
                                                                    </xsl:for-each>
                                                                </table>
                                                            </div>
                                                        </xsl:if>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>
                            </xsl:element>
                        </div>
                   </xsl:element>
                </div>
            </xsl:element>
        </xsl:for-each>
        <!-- end interfaces -->

        <!-- classes -->
        <xsl:for-each select="/project/file/class" >
            <xsl:variable name="constantCount" select="count(constant)" />
            <xsl:variable name="methodCount" select="count(method)" />
            <xsl:variable name="propertyCount" select="count(property[@visibility='public'])" />
            <xsl:variable name="classId" select="concat('', translate(full_name, '\', '_'))" />
            <xsl:variable name="constantsId" select="concat('constants_', translate(full_name, '\', '_'))" />
            <xsl:variable name="methodsId" select="concat('methods_', translate(full_name, '\', '_'))" />
            <xsl:element name="div">
                <xsl:attribute name="class">accordion</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="$classId" /></xsl:attribute>
                <div class="accordion-group">
                    <xsl:element name="div">
                        <xsl:attribute name="class">accordion-heading</xsl:attribute>
                        <xsl:element name="a">
                            <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                            <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                            <xsl:attribute name="data-parent"><xsl:value-of select="concat('#', $classId)" /></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('#collapse', $classId)" /></xsl:attribute>
                            <h2><xsl:value-of select="full_name" /></h2>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id"><xsl:value-of select="concat('collapse', $classId)" /></xsl:attribute>
                        <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                        <div class="accordion-inner">
                            <!-- Here we insert another nested accordion -->
                            <xsl:element name="div">
                                <xsl:attribute name="id"><xsl:value-of select="concat('accordian', $classId)" /></xsl:attribute>
                                <xsl:attribute name="class">accordion</xsl:attribute>

                                <xsl:variable name="hasExtends">
                                    <xsl:for-each select="extends">
                                        <xsl:if test=". != ''">
                                            <xsl:value-of select="." />
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="$hasExtends != ''">
                                    <h3>Extends</h3>
                                    <xsl:for-each select="extends">
                                        <xsl:if test=". != ''">
                                           <xsl:element name="a">
                                               <xsl:attribute name="href">
                                                   <xsl:value-of select="concat('#', translate(., '\', '_'))" />
                                               </xsl:attribute>
                                               <code><xsl:value-of select="." /></code>
                                           </xsl:element>
                                           <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>

                                <xsl:variable name="hasImplements">
                                    <xsl:for-each select="implements">
                                        <xsl:if test=". != ''">
                                            <xsl:value-of select="." />
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="$hasImplements != ''">
                                    <h3>Implements</h3>
                                    <xsl:for-each select="implements">
                                        <xsl:if test=". != ''">
                                           <xsl:element name="a">
                                               <xsl:attribute name="href">
                                                   <xsl:value-of select="concat('#', translate(., '\', '_'))" />
                                               </xsl:attribute>
                                               <code><xsl:value-of select="." /></code>
                                           </xsl:element>
                                           <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>

                                <xsl:if test="$constantCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $classId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseConstants', $classId)" /></xsl:attribute>
                                                <h3>Constants</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseConstants', $classId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <xsl:for-each select="constant">
                                                    <div class="row">
                                                        <div class="col-md-12 pull-left">
                                                            <h4><xsl:value-of select="../name" />::<xsl:value-of select="name" /></h4>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <p><xsl:value-of select="docblock/description" /></p>
                                                            <table class="table">
                                                                <xsl:for-each select="docblock/tag">
                                                                    <tr>
                                                                        <td>
                                                                            <strong><xsl:value-of select="@name" /></strong>
                                                                        </td>
                                                                        <td>
                                                                            <xsl:value-of select="@description" />
                                                                        </td>
                                                                    </tr>
                                                                </xsl:for-each>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>

                                <xsl:if test="$propertyCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $classId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseProperties', $classId)" /></xsl:attribute>
                                                <h3>Properties</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseProperties', $classId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <div class="row">
                                                    <div class="col-md-11 col-md-offset-1">
                                                        <table class="table table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th>Name</th>
                                                                    <th>Type</th>
                                                                    <th>Description</th>
                                                                    <th>Read-Only</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <xsl:for-each select="property[@visibility='public']">
                                                                    <xsl:variable name="readOnly" select="count(docblock/tag[@name='property-read'])" />
                                                                    <tr>
                                                                        <td><xsl:value-of select="name" /></td>
                                                                        <td><xsl:value-of select="docblock/tag[@name='var']/@type" /></td>
                                                                        <td><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', docblock/description)" /></td>
                                                                        <td>
                                                                           <xsl:if test="$readOnly != 0">
                                                                               <i class="fa fa-check"></i>
                                                                           </xsl:if>
                                                                        </td>
                                                                    </tr>
                                                                </xsl:for-each>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>

                                <xsl:if test="$methodCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $classId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseMethods', $classId)" /></xsl:attribute>
                                                <h3>Methods</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseMethods', $classId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <xsl:for-each select="method">
                                                    <div class="row">
                                                        <div class="col-md-12 pull-left">
                                                            <h4><xsl:value-of select="../name" />::<xsl:value-of select="name" />()</h4>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', docblock/description)" /></p>
                                                            <p>
                                                                <xsl:if test="@final = 'true'">
                                                                    <span class="label label-default">FINAL</span>
                                                                    <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
                                                                </xsl:if>

                                                                <xsl:if test="@static = 'true'">
                                                                    <span class="label label-default">STATIC</span>
                                                                </xsl:if>
                                                            </p>
                                                            <pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre>
                                                            <xsl:variable name="parameterCount" select="count(docblock/tag[@name='param'])" />
                                                            <xsl:if test="$parameterCount &gt; 0">
                                                                <h5>Parameters</h5>
                                                                <table class="table table-bordered">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Name</th>
                                                                            <th>Type</th>
                                                                            <th>Description</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <xsl:for-each select="docblock/tag[@name='param']">
                                                                            <tr>
                                                                                <td><xsl:value-of select="@variable" /></td>
                                                                                <td><code><xsl:value-of select="@type" /></code></td>
                                                                                <td><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></td>
                                                                            </tr>
                                                                        </xsl:for-each>
                                                                    </tbody>
                                                                </table>
                                                            </xsl:if>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <h5>Return Value</h5>
                                                            <xsl:choose>
                                                                <xsl:when test="docblock/tag[@name='return']/type != 'void'">
                                                                    <code><xsl:value-of select="docblock/tag[@name='return']/@type" /></code>
                                                                    <p><xsl:value-of select="docblock/tag[@name='return']/@description" /></p>
                                                                </xsl:when>
                                                                <xsl:otherwise>void</xsl:otherwise>
                                                            </xsl:choose>
                                                        </div>
                                                        <xsl:variable name="exceptionCount" select="count(docblock/tag[@name='throws'])" />
                                                        <xsl:if test="$exceptionCount &gt; 0">
                                                            <div class="col-md-11 col-md-offset-1">
                                                                <h5>Exceptions</h5>
                                                                <table class="table">
                                                                    <xsl:for-each select="docblock/tag[@name='throws']">
                                                                         <tr>
                                                                            <td><code><xsl:value-of select="@type" /></code></td>
                                                                            <td><xsl:value-of select="@description" /></td>
                                                                         </tr>
                                                                    </xsl:for-each>
                                                                </table>
                                                            </div>
                                                        </xsl:if>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>
                            </xsl:element>
                        </div>
                   </xsl:element>
                </div>
            </xsl:element>
        </xsl:for-each>
        <!-- end classes -->

        <!-- traits -->
        <xsl:for-each select="/project/file/trait" >
            <xsl:variable name="methodCount" select="count(method)" />
            <xsl:variable name="traitId" select="concat('', translate(full_name, '\', '_'))" />
            <xsl:variable name="methodsId" select="concat('methods_', translate(full_name, '\', '_'))" />
            <xsl:element name="div">
                <xsl:attribute name="class">accordion</xsl:attribute>
                <xsl:attribute name="id"><xsl:value-of select="$traitId" /></xsl:attribute>
                <div class="accordion-group">
                    <xsl:element name="div">
                        <xsl:attribute name="class">accordion-heading</xsl:attribute>
                        <xsl:element name="a">
                            <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                            <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                            <xsl:attribute name="data-parent"><xsl:value-of select="concat('#', $traitId)" /></xsl:attribute>
                            <xsl:attribute name="href"><xsl:value-of select="concat('#collapse', $traitId)" /></xsl:attribute>
                            <h2><xsl:value-of select="full_name" /></h2>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id"><xsl:value-of select="concat('collapse', $traitId)" /></xsl:attribute>
                        <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                        <div class="accordion-inner">
                            <!-- Here we insert another nested accordion -->
                            <xsl:element name="div">
                                <xsl:attribute name="id"><xsl:value-of select="concat('accordian', $traitId)" /></xsl:attribute>
                                <xsl:attribute name="class">accordion</xsl:attribute>
                                <xsl:if test="$methodCount &gt; 0">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                           <xsl:element name="a">
                                               <xsl:attribute name="class">accordion-toggle</xsl:attribute>
                                               <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                                               <xsl:attribute name="data-parent"><xsl:value-of select="concat('#accordian', $traitId)" /></xsl:attribute>
                                               <xsl:attribute name="href"><xsl:value-of select="concat('#collapseMethods', $traitId)" /></xsl:attribute>
                                                <h3>Methods</h3>
                                            </xsl:element>
                                        </div>
                                        <xsl:element name="div">
                                            <xsl:attribute name="id"><xsl:value-of select="concat('collapseMethods', $traitId)" /></xsl:attribute>
                                            <xsl:attribute name="class">accordion-body collapse in</xsl:attribute>
                                            <div class="accordion-inner">
                                                <xsl:for-each select="method">
                                                    <div class="row">
                                                        <div class="col-md-12 pull-left">
                                                            <h4><xsl:value-of select="../name" />::<xsl:value-of select="name" />()</h4>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <p><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', docblock/description)" /></p>
                                                            <pre><xsl:value-of select="php:function('\Pholio\Util\Xslt::signature', current())" /></pre>
                                                            <xsl:variable name="parameterCount" select="count(docblock/tag[@name='param'])" />
                                                            <xsl:if test="$parameterCount &gt; 0">
                                                                <h5>Parameters</h5>
                                                                <table class="table table-bordered">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Name</th>
                                                                            <th>Type</th>
                                                                            <th>Description</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <xsl:for-each select="docblock/tag[@name='param']">
                                                                            <tr>
                                                                                <td><xsl:value-of select="@variable" /></td>
                                                                                <td><code><xsl:value-of select="@type" /></code></td>
                                                                                <td><xsl:value-of select="php:function('\Pholio\Util\Xslt::stripTags', @description)" /></td>
                                                                            </tr>
                                                                        </xsl:for-each>
                                                                    </tbody>
                                                                </table>
                                                            </xsl:if>
                                                        </div>
                                                        <div class="col-md-11 col-md-offset-1">
                                                            <h5>Return Value</h5>
                                                            <xsl:choose>
                                                                <xsl:when test="docblock/tag[@name='return']/type != 'void'">
                                                                    <code><xsl:value-of select="docblock/tag[@name='return']/@type" /></code>
                                                                    <p><xsl:value-of select="docblock/tag[@name='return']/@description" /></p>
                                                                </xsl:when>
                                                                <xsl:otherwise>void</xsl:otherwise>
                                                            </xsl:choose>
                                                        </div>
                                                        <xsl:variable name="exceptionCount" select="count(docblock/tag[@name='throws'])" />
                                                        <xsl:if test="$exceptionCount &gt; 0">
                                                            <div class="col-md-11 col-md-offset-1">
                                                                <h5>Exceptions</h5>
                                                                <table class="table">
                                                                    <xsl:for-each select="docblock/tag[@name='throws']">
                                                                         <tr>
                                                                            <td><code><xsl:value-of select="@type" /></code></td>
                                                                            <td><xsl:value-of select="@description" /></td>
                                                                         </tr>
                                                                    </xsl:for-each>
                                                                </table>
                                                            </div>
                                                        </xsl:if>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:element>
                                    </div>
                                </xsl:if>
                            </xsl:element>
                        </div>
                   </xsl:element>
                </div>
            </xsl:element>
        </xsl:for-each>
        <!-- end traits -->

    </xsl:template>
</xsl:stylesheet>
