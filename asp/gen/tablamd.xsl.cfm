<cfoutput><?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:c="collection" xmlns:a="attribute" xmlns:o="object" >

    <xsl:output method="xml" encoding="iso-8859-1" indent="yes" />
	<xsl:param name="code" select="'#XMLFormat(url.code)#'" />
    <xsl:key name="Key" match="o:Key" use="@Id"/>
    <xsl:key name="Col" match="o:Column" use="@Id"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//o:Table[a:Code=$code]" />
    </xsl:template>

    <xsl:template match="o:Table">
        <table>
            <xsl:apply-templates select="a:Code" />
            <xsl:apply-templates select="a:Name" />
            <xsl:apply-templates select="c:Columns/o:Column" />
            <pk><xsl:apply-templates select="key('Key',c:PrimaryKey/o:Key/@Ref)" /></pk>
            <keys><xsl:apply-templates select="c:Keys/o:Key" /></keys>
        </table>
    </xsl:template>

    <xsl:template match="//o:Column">
        <cols>
            <xsl:apply-templates select="a:Code" />
            <xsl:apply-templates select="a:Name" />
			<mandatory><xsl:choose><xsl:when test="a:Mandatory">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></mandatory>
			<identity><xsl:choose><xsl:when test="a:Identity">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></identity>
            <length><xsl:value-of select="a:Length" /></length>
            <xsl:apply-templates select="a:Precision" />
            <xsl:apply-templates select="a:DefaultValue" />
            <xsl:apply-templates select="a:ListOfValues" />
            <xsl:apply-templates select="a:DataType" />
			<ispk><xsl:value-of select="count(key('Col', key('Key',../../c:PrimaryKey/o:Key/@Ref)/c:Key.Columns/o:Column/@Ref)[a:Code = current()/a:Code]) " /></ispk>
        </cols>
    </xsl:template>

    <xsl:template match="a:Code"><code><xsl:value-of select="." /></code></xsl:template>
    <xsl:template match="a:Name"><name><xsl:value-of select="." /></name></xsl:template>
	<!---
    <xsl:template match="a:Mandatory"><mand><xsl:value-of select="." /></mand></xsl:template>
    <xsl:template match="a:Identity"><idnt><xsl:value-of select="." /></idnt></xsl:template>
    <xsl:template match="a:Length"><length><xsl:value-of select="." /></length></xsl:template>
	--->
    <xsl:template match="a:Precision"><precision><xsl:value-of select="." /></precision></xsl:template>
    <xsl:template match="a:DefaultValue"><default><xsl:value-of select="." /></default></xsl:template>
    <xsl:template match="a:DataType">
        <xsl:variable name="typename"
            select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ', 'abcdefghijklmnopqrstuvwxyz_')" 
            />
        <type><xsl:value-of select="$typename" /></type>
		<javatype><xsl:choose>
			<xsl:when test="contains($typename, 'char')"     >java.lang.String</xsl:when>
			<xsl:when test="contains($typename, 'int')"      >long</xsl:when>
			<!--
			<xsl:when test="contains($typename, 'binary')"   >byte[]</xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  >java.math.BigDecimal</xsl:when>
			<xsl:when test="contains($typename, 'money')"    >java.math.BigDecimal</xsl:when>
			<xsl:when test="contains($typename, 'date')"     >java.sql.Date</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >java.sql.Time</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">java.sql.Timestamp</xsl:when>
			-->
			<xsl:when test="contains($typename, 'binary')"   >BCD.Binary</xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  >BCD.Decimal</xsl:when>
			<xsl:when test="contains($typename, 'money')"    >BCD.Money</xsl:when>
			<xsl:when test="contains($typename, 'date')"     >MJD.Date</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >MJD.Time</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">MJD.Timestamp</xsl:when>
			
			<xsl:otherwise>java.lang.Object</xsl:otherwise>
		</xsl:choose></javatype>
		<texttype><xsl:choose>
			<xsl:when test="contains($typename, 'char')">C</xsl:when>
			<xsl:when test="contains($typename, 'text')">C</xsl:when>
			<xsl:when test="contains($typename, 'image')">B</xsl:when>
			<xsl:when test="contains($typename, 'int')">N</xsl:when>
			<xsl:when test="contains($typename, 'binary')">B</xsl:when>
			<xsl:when test="contains($typename, 'numeric')">N</xsl:when>
			<xsl:when test="contains($typename, 'decimal')">N</xsl:when>
			<xsl:when test="contains($typename, 'money')">N</xsl:when>
			<xsl:when test="contains($typename, 'date')">D</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">B</xsl:when>
			<xsl:when test="contains($typename, 'time')">T</xsl:when>
			<xsl:when test="contains($typename, 'bit')">L</xsl:when>
			<xsl:when test="contains($typename, 'float')">N</xsl:when>
			<xsl:when test="contains($typename, 'real')">N</xsl:when>
			<xsl:when test="contains($typename, 'double')">N</xsl:when>
			<xsl:otherwise>C</xsl:otherwise>
		</xsl:choose></texttype>
		<textlen><xsl:choose>
			<xsl:when test="contains($typename, 'char')"     ><xsl:value-of select="../a:Length" /></xsl:when>
			<xsl:when test="contains($typename, 'tinyint')"  >3</xsl:when>
			<xsl:when test="contains($typename, 'smallint')" >6</xsl:when>
			<xsl:when test="contains($typename, 'int')"      >11</xsl:when>
			<xsl:when test="contains($typename, 'binary')"   ><xsl:value-of select="../a:Length*2+2" /></xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  ><xsl:value-of select="../a:Length" /></xsl:when>
			<xsl:when test="contains($typename, 'decimal')"  ><xsl:value-of select="../a:Length" /></xsl:when>
			<xsl:when test="contains($typename, 'money')"    ><xsl:value-of select="../a:Length" /></xsl:when>
			<xsl:when test="contains($typename, 'date')"     >10</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">20</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >8</xsl:when>
			<xsl:when test="contains($typename, 'bit')"      >1</xsl:when>
			<xsl:when test="contains($typename, 'float')"    >15</xsl:when>
			<xsl:when test="contains($typename, 'real')"     >15</xsl:when>
			<xsl:when test="contains($typename, 'double')"   >15</xsl:when>
			<xsl:otherwise>20</xsl:otherwise>
			<!-- faltan [luego los pongo] : -5 BIGINT, -4 LONGVARBINARY, -1 LONGVARCHAR -->
		</xsl:choose></textlen>
		<textdec><xsl:choose>
			<xsl:when test="contains($typename, 'numeric') and string-length(../a:Precision)>0"><xsl:value-of select="../a:Precision"/></xsl:when>
			<xsl:when test="contains($typename, 'dec') and string-length(../a:Precision)>0"><xsl:value-of select="../a:Precision"/></xsl:when>
			<xsl:when test="contains($typename, 'money')">2</xsl:when>
			<xsl:when test="contains($typename, 'float')">15</xsl:when>
			<xsl:when test="contains($typename, 'real')">6</xsl:when>
			<xsl:when test="contains($typename, 'double')">15</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></textdec>
		<jdbc-type><xsl:choose>
			<xsl:when test="contains($typename, 'varchar')"  >12</xsl:when>
			<xsl:when test="contains($typename, 'char')"     >1</xsl:when>
			<xsl:when test="contains($typename, 'tinyint')"  >-6</xsl:when>
			<xsl:when test="contains($typename, 'smallint')" >5</xsl:when>
			<xsl:when test="contains($typename, 'int')"      >4</xsl:when>
			<xsl:when test="contains($typename, 'varbinary')">-3</xsl:when>
			<xsl:when test="contains($typename, 'binary')"   >-2</xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  >2</xsl:when>
			<xsl:when test="contains($typename, 'decimal')"  >3</xsl:when>
			<xsl:when test="contains($typename, 'money')"    >2</xsl:when>
			<xsl:when test="contains($typename, 'date')"     >91</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">93</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >92</xsl:when>
			<xsl:when test="contains($typename, 'bit')"      >-7</xsl:when>
			<xsl:when test="contains($typename, 'float')"    >6</xsl:when>
			<xsl:when test="contains($typename, 'real')"     >7</xsl:when>
			<xsl:when test="contains($typename, 'double')"   >8</xsl:when>
			<xsl:otherwise>12</xsl:otherwise>
			<!-- faltan [luego los pongo] : -5 BIGINT, -4 LONGVARBINARY, -1 LONGVARCHAR -->
		</xsl:choose></jdbc-type>
		<coldfusiontype><xsl:choose>
			<xsl:when test="contains($typename, 'char')"     >cf_sql_char</xsl:when>
			<xsl:when test="contains($typename, 'text')"     >cf_sql_char</xsl:when>
			<xsl:when test="contains($typename, 'image')"    >cf_sql_blob</xsl:when>
			<xsl:when test="contains($typename, 'tinyint')"  >cf_sql_integer</xsl:when>
			<xsl:when test="contains($typename, 'smallint')" >cf_sql_integer</xsl:when>
			<xsl:when test="contains($typename, 'int')"      >cf_sql_integer</xsl:when>
			<xsl:when test="contains($typename, 'binary')"   >cf_sql_binary</xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  >cf_sql_numeric</xsl:when>
			<xsl:when test="contains($typename, 'decimal')"  >cf_sql_decimal</xsl:when>
			<xsl:when test="contains($typename, 'money')"    >cf_sql_money</xsl:when>
			<xsl:when test="contains($typename, 'date')"     >cf_sql_date</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">cf_sql_binary</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >cf_sql_time</xsl:when>
			<xsl:when test="contains($typename, 'bit')"      >cf_sql_bit</xsl:when>
			<xsl:when test="contains($typename, 'float')"    >cf_sql_float</xsl:when>
			<xsl:when test="contains($typename, 'real')"     >cf_sql_float</xsl:when>
			<xsl:when test="contains($typename, 'double')"   >cf_sql_double</xsl:when>
			<xsl:otherwise>cf_sql_##<xsl:value-of select="$typename" /></xsl:otherwise>
		</xsl:choose></coldfusiontype>
		<argumenttype><xsl:choose>
			<xsl:when test="contains($typename, 'char')"     >string</xsl:when>
			<xsl:when test="contains($typename, 'text')"     >string</xsl:when>
			<xsl:when test="contains($typename, 'image')"    >binary</xsl:when>
			<xsl:when test="contains($typename, 'tinyint')"  >numeric</xsl:when>
			<xsl:when test="contains($typename, 'smallint')" >numeric</xsl:when>
			<xsl:when test="contains($typename, 'int')"      >numeric</xsl:when>
			<xsl:when test="contains($typename, 'binary')"   >binary</xsl:when>
			<xsl:when test="contains($typename, 'numeric')"  >numeric</xsl:when>
			<xsl:when test="contains($typename, 'decimal')"  >numeric</xsl:when>
			<xsl:when test="contains($typename, 'money')"    >numeric</xsl:when>
			<xsl:when test="contains($typename, 'date')"     >date</xsl:when>
			<xsl:when test="contains($typename, 'timestamp')">string</xsl:when>
			<xsl:when test="contains($typename, 'time')"     >date</xsl:when>
			<xsl:when test="contains($typename, 'bit')"      >boolean</xsl:when>
			<xsl:when test="contains($typename, 'float')"    >numeric</xsl:when>
			<xsl:when test="contains($typename, 'real')"     >numeric</xsl:when>
			<xsl:when test="contains($typename, 'double')"   >numeric</xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose></argumenttype>
        <quote>
            <xsl:value-of select="contains($typename,'char') or contains($typename,'date')" />
        </quote>
    </xsl:template>
    
    <xsl:template match="a:ListOfValues">
        <!-- no se me ocurrio como ponerlo en un while() -->
            <!--poner un enter al final-->
            <xsl:variable name="b1"  select="concat(., '&##10;')" />
            <xsl:variable name="v1"  select="substring-before($b1,  '&##10;')" />
            <xsl:variable name="b2"  select="substring-after ($b1,  '&##10;')" />
            <xsl:variable name="v2"  select="substring-before($b2,  '&##10;')" />
            <xsl:variable name="b3"  select="substring-after ($b2,  '&##10;')" />
            <xsl:variable name="v3"  select="substring-before($b3,  '&##10;')" />
            <xsl:variable name="b4"  select="substring-after ($b3,  '&##10;')" />
            <xsl:variable name="v4"  select="substring-before($b4,  '&##10;')" />
            <xsl:variable name="b5"  select="substring-after ($b4,  '&##10;')" />
            <xsl:variable name="v5"  select="substring-before($b5,  '&##10;')" />
            <xsl:variable name="b6"  select="substring-after ($b5,  '&##10;')" />
            <xsl:variable name="v6"  select="substring-before($b6,  '&##10;')" />
            <xsl:variable name="b7"  select="substring-after ($b6,  '&##10;')" />
            <xsl:variable name="v7"  select="substring-before($b7,  '&##10;')" />
            <xsl:variable name="b8"  select="substring-after ($b7,  '&##10;')" />
            <xsl:variable name="v8"  select="substring-before($b8,  '&##10;')" />
            <xsl:variable name="b9"  select="substring-after ($b8,  '&##10;')" />
            <xsl:variable name="v9"  select="substring-before($b9,  '&##10;')" />
            <xsl:variable name="b10" select="substring-after ($b9,  '&##10;')" />
            <xsl:variable name="v10" select="substring-before($b10, '&##10;')" />
            <xsl:variable name="b11" select="substring-after ($b10, '&##10;')" />
            <xsl:variable name="v11" select="substring-before($b11, '&##10;')" />
            <xsl:variable name="b12" select="substring-after ($b11, '&##10;')" />
            <xsl:variable name="v12" select="substring-before($b12, '&##10;')" />
            <xsl:variable name="b13" select="substring-after ($b12, '&##10;')" />
            <xsl:variable name="v13" select="substring-before($b13, '&##10;')" />
            <xsl:variable name="b14" select="substring-after ($b13, '&##10;')" />
            <xsl:variable name="v14" select="substring-before($b14, '&##10;')" />
            <xsl:variable name="b15" select="substring-after ($b14, '&##10;')" />
            <xsl:variable name="v15" select="substring-before($b15, '&##10;')" />
            <xsl:variable name="b16" select="substring-after ($b15, '&##10;')" />
            <xsl:variable name="v16" select="substring-before($b16, '&##10;')" />
            <xsl:variable name="b17" select="substring-after ($b16, '&##10;')" />
            <xsl:variable name="v17" select="substring-before($b17, '&##10;')" />
            <xsl:variable name="b18" select="substring-after ($b17, '&##10;')" />
            <xsl:variable name="v18" select="substring-before($b18, '&##10;')" />
            <xsl:variable name="b19" select="substring-after ($b18, '&##10;')" />
            <xsl:variable name="v19" select="substring-before($b19, '&##10;')" />
            <xsl:variable name="b20" select="substring-after ($b19, '&##10;')" />
            <xsl:variable name="v20" select="substring-before($b20, '&##10;')" />

            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v1"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v2"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v3"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v4"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v5"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v6"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v7"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v8"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v9"  /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v10" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v11" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v12" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v13" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v14" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v15" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v16" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v17" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v18" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v19" /></xsl:call-template>
            <xsl:call-template name="unvalor"><xsl:with-param name="valor" select="$v20" /></xsl:call-template>
    </xsl:template>
    
    <xsl:template name="unvalor">
        <xsl:param name="valor" />
        <xsl:if test="string-length($valor) > 0" >
            <values>
				<xsl:variable name="code" select="substring-before($valor, '&##9;')" />
				<xsl:variable name="name" select="substring-after($valor, '&##9;')" />
                <code><xsl:value-of select="$code" /></code>
				<name><xsl:if test="string-length($name)>0"><xsl:value-of select="$name" /></xsl:if>
					  <xsl:if test="string-length($name)=0"><xsl:value-of select="$code" /></xsl:if>
				</name>
            </values>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="//o:Key">
		<name><xsl:value-of select="a:Name" /></name>
		<code><xsl:value-of select="a:Code" /></code>
			<xsl:apply-templates select="key('Col',c:Key.Columns/o:Column/@Ref)" />
    </xsl:template>

</xsl:stylesheet></cfoutput>