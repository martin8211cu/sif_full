<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:c="collection" xmlns:a="attribute" xmlns:o="object" >
    
    <xsl:output method="xml" encoding="iso-8859-1" />
<cfoutput>
	<xsl:param name="Diagram" select="'#XMLFormat(url.Diagram)#'" />
	<xsl:param name="Table" select="'#XMLFormat(url.Code)#'" />
</cfoutput>
    <xsl:key name="Table" match="o:Table" use="@Id"/>
    <xsl:key name="Refr1" match="o:Reference" use="c:Object1/o:Table/@Ref"/>
    <xsl:key name="Refr2" match="o:Reference" use="c:Object2/o:Table/@Ref"/>
    
    <xsl:template match="/">
       
			<table width="100%" border="0" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><tr><td valign="top">
				<form>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr><th>Diagramas</th></tr>
				<tr><td>
					<select name="Diagram" onchange="this.form.submit()">
					<xsl:for-each select="//o:PhysicalDiagram[a:Code]">
						<xsl:sort select="a:Code" />
						<option value="{a:Code}">
							<xsl:if test="a:Code=$Diagram">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="a:Code" /> -
							<xsl:value-of select="a:Name" />
						</option>
					</xsl:for-each>
					</select>
				</td></tr>
				<tr><th>Tablas de <xsl:value-of select="$Diagram" /></th></tr>
				<tr><td>
					<xsl:if test="//o:PhysicalDiagram">
						<select name="Code" onchange="this.form.submit()">
						<xsl:for-each select="key('Table', //o:PhysicalDiagram[a:Code=$Diagram]//o:Table/@Ref)">
							<xsl:sort select="a:Code" />
							<option value="{a:Code}">
								<xsl:if test="a:Code=$Table">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="a:Code" /> - 
								<xsl:value-of select="a:Name" />
							</option>
						</xsl:for-each>
						</select>
					</xsl:if>
				</td></tr>
				</table>
				</form>
				</td><td valign="top">
					<xsl:choose>
					<xsl:when test="//o:Table[a:Code=$Table]">
						<xsl:for-each select="//o:Table[a:Code=$Table]">
						<form target="gen" action="gen.cfm">
						
							<table width="100%" border="0" style="border:solid 1px" cellpadding="1" cellspacing="0" >
							<tr><td colspan='5' style='border-bottom:1px solid black'><strong><xsl:value-of select="$Table"/></strong></td></tr>
							<tr><th>Lista</th><th>Editar</th><th>Columna</th><th>Tipo</th><th>Nulos</th></tr>
							<xsl:for-each select=".//c:Columns/o:Column">
								<tr><td>
									<input type="checkbox" name="listar" value="{a:Code}" />
								</td><td>
									<input type="checkbox" name="editar" value="{a:Code}" checked="checked" />
								</td><td>
								<xsl:value-of select="a:Code" />
								</td><td><xsl:value-of select="a:DataType" />
								</td><td>
									<xsl:if test="./a:Mandatory=1">
										not null
									</xsl:if>
									<xsl:if test="./a:Mandatory=0">
										null
									</xsl:if>
								</td></tr>
							</xsl:for-each>
							</table><br/>
							<xsl:if test="key('Refr1', @Id)">
								<table width="100%" border="0" style="border:solid 1px" >
								<tr><th colspan="2">Tabla hija</th><th>Referencia</th></tr>
								<xsl:for-each select="key('Refr1', @Id)">
									<tr><td>
									<input type="checkbox" name="hija" value="{c:Object2/o:Table/@Ref}" />
									</td><td>
									<xsl:value-of select="key('Table', c:Object2/o:Table/@Ref)/a:Name" />
									</td><td>
									<xsl:value-of select="a:Name" />
									</td></tr>
								</xsl:for-each>
								</table><br/>
							</xsl:if>
							<xsl:if test="key('Refr2', @Id)">
								<table width="100%" border="0" style="border:solid 1px" >
								<tr><th colspan="2">Tabla padre</th><th>Referencia</th></tr>
								<xsl:for-each select="key('Refr2', @Id)">
									<tr><td>
									<input type="checkbox" name="padre" value="{c:Object1/o:Table/@Ref}" />
									</td><td>
									<xsl:value-of select="key('Table', c:Object1/o:Table/@Ref)/a:Name" />
									</td><td>
									<xsl:value-of select="a:Name" />
									</td></tr>
								</xsl:for-each>
								</table><br/>
							</xsl:if>
							<input type="hidden" name="code" value="{$Table}" />
							<input type="submit" value="Generar" />
						</form>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						[ Sin tabla ] 
					</xsl:otherwise>
					</xsl:choose>
				</td></tr></table>

    </xsl:template>
    
</xsl:stylesheet>