<xsl:template match="*" mode="resumen" >
    <fo:block font-family="sans-serif" font-size='14pt' text-align='center'>
        Hoja de control
    </fo:block>
    <fo:block font-family="sans-serif" font-size='12pt' text-align='center' space-after="1cm" >
        Cartas de afiliacion
    </fo:block>
    <fo:block font-family="sans-serif" font-size='8pt'>
        <fo:table border="1px solid black" padding="0.25cm" >
            <fo:table-column column-width="0.85in" /> <!--- rol --->
            <fo:table-column column-width="2.00in" /> <!--- nombre --->
            <fo:table-column column-width="0.75in" /> <!--- Pid --->
            <fo:table-column column-width="1.50in" /> <!--- Pemail1 --->
            <fo:table-column column-width="0.75in" /> <!--- Usueplogin --->
            <fo:table-column column-width="0.75in" /> <!--- CAnumero --->
            
            <fo:table-header>
                <fo:table-row padding="4px" >
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Tipo      </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Nombre    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Cedula    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Correo    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Usuario   </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block background-color="black" color="white" font-weight="bold" padding="4px">Ref       </fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:apply-templates select="Paquete/persona" mode="resumen" />
            </fo:table-body>
        </fo:table>
    </fo:block>
</xsl:template>

<xsl:template match="persona" mode="resumen" >
	<xsl:variable name="bgcolor">
		<xsl:choose>
			<xsl:when test="(position()-1) mod 4 &lt; 2">
				#fff
			</xsl:when>
			<xsl:otherwise>
				#eee
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    <fo:table-row padding="4px" background-color="{$bgcolor}">
        <fo:table-cell><fo:block padding="4px" >
            <xsl:value-of select="rol"   />
        </fo:block></fo:table-cell>
        <fo:table-cell><fo:block padding="4px">
            <xsl:value-of select="Pnombre"    />  
            <xsl:value-of select="Papellido1" />  
            <xsl:value-of select="Papellido2" />
        </fo:block></fo:table-cell>
        <fo:table-cell><fo:block padding="4px">
            <xsl:value-of select="Pid"        />
        </fo:block></fo:table-cell>
        <fo:table-cell><fo:block padding="4px">
            <xsl:value-of select="Pemail1"    />
        </fo:block></fo:table-cell>
        <fo:table-cell><fo:block padding="4px">
            <xsl:value-of select="Usueplogin" />
        </fo:block></fo:table-cell>
        <fo:table-cell><fo:block padding="4px">
            <xsl:value-of select="CAnumero"   />
        </fo:block></fo:table-cell >
    </fo:table-row>
</xsl:template>
