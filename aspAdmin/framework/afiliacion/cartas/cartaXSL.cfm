<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	version="1.0">
<xsl:template match="Carta">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
        <fo:layout-master-set>
    
            <fo:simple-page-master master-name="all"
                page-height="11in" page-width="8.5in"
                margin-top="0.6in" margin-bottom="0.6in" 
                margin-left="0.8in" margin-right="0.8in">
                <fo:region-body margin-top="0.5in" margin-bottom="0in" 
                    border-before-style="solid"
                    border-before-color="blue"
                    />
                <fo:region-before extent="1.25in" />
                <fo:region-after extent="0in"/>
            </fo:simple-page-master>
    
        </fo:layout-master-set>
    
        <xsl:apply-templates select="Paquete" />

		<fo:page-sequence master-name="all" format="i">
			<fo:static-content flow-name="xsl-region-before">
				<fo:block text-align="end" 
					font-size="10pt" font-family="serif" line-height="1em + 2pt">
	
				</fo:block>
				<fo:block text-align="end" 
					font-size="6pt" font-family="serif" line-height="1em + 2pt">
					migestion.net © 2003
				</fo:block>
				<fo:block text-align="end" 
					font-size="6pt" font-family="serif" line-height="1em + 2pt">
					Todos los derechos reservados
				</fo:block>
			</fo:static-content> 
		
			<fo:static-content flow-name="xsl-region-after">
				<fo:block text-align="start" 
					font-size="10pt" font-family="serif" line-height="1em + 2pt">
				</fo:block>
			</fo:static-content> 
			<fo:flow flow-name="xsl-region-body">
				<xsl:apply-templates select="." mode="resumen" />
			</fo:flow>
		</fo:page-sequence>
		
    </fo:root>
</xsl:template>

<xsl:template match="Paquete" >
    <fo:page-sequence master-name="all" format="i">
        <fo:static-content flow-name="xsl-region-before">
            <fo:block text-align="end" 
                font-size="10pt" font-family="serif" line-height="1em + 2pt">

            </fo:block>
            <fo:block text-align="end" 
                font-size="6pt" font-family="serif" line-height="1em + 2pt">
                migestion.net © 2003
            </fo:block>
            <fo:block text-align="end" 
                font-size="6pt" font-family="serif" line-height="1em + 2pt">
                Todos los derechos reservados
            </fo:block>
        </fo:static-content> 
    
        <fo:static-content flow-name="xsl-region-after">
            <fo:block text-align="start" 
                font-size="10pt" font-family="serif" line-height="1em + 2pt">
            </fo:block>
        </fo:static-content> 
    
        <fo:flow flow-name="xsl-region-body">
			<xsl:for-each select="persona">
				<xsl:variable name="nn" select="position()"/>
				<fo:block font-size="10pt">
					<xsl:if test="position() != 1">
						<xsl:attribute name="break-before">page</xsl:attribute>
					</xsl:if>
					<fo:block break-after="page">
						<xsl:apply-templates select="." mode="comun2">
							<xsl:with-param name="AdminRol"        select="'Administrador'" />
							<xsl:with-param name="AdminNombre"     select="//AdminNombre" />
							<xsl:with-param name="Rolinfo"         select="//roles/rol[rol=current()/rol]/Rolinfo" />
							<xsl:with-param name="copia"           select="'usuario'" />
						</xsl:apply-templates>
					</fo:block>
					<fo:block>
						<xsl:apply-templates select="." mode="comun2">
							<xsl:with-param name="AdminRol"        select="'Administrador'" />
							<xsl:with-param name="AdminNombre"     select="//AdminNombre" />
							<xsl:with-param name="Rolinfo"         select="//roles/rol[rol=current()/rol]/Rolinfo" />
							<xsl:with-param name="copia"           select="'portal'" />
						</xsl:apply-templates>
					</fo:block>
				</fo:block>
			</xsl:for-each>
        </fo:flow>
    </fo:page-sequence>
</xsl:template>

<!-- Esto estaba en comun2 -->
<xsl:template match="persona" mode="comun2" >
    <xsl:param name="AdminRol" />
    <xsl:param name="AdminNombre" />
    <xsl:param name="Roldescripcion" />
    <xsl:param name="Rolinfo" />
    <xsl:param name="copia" />
    <xsl:param name="autHijos" />
    
    <fo:block font-size="10pt" text-align="justify">
        <fo:block>
            San José, <xsl:value-of select="fecha" />
        </fo:block><fo:block space-after="6pt">
            Referencia No.:  <fo:inline font-weight="bold"><xsl:value-of select="CAnumero" /></fo:inline>
        </fo:block>
        
        <fo:block space-before="10pt" space-after="10pt" font-weight="bold" font-size="14pt" text-align="center" >
                Bienvenido a la Comunidad Digital de <xsl:value-of select="CEnombre" />
        </fo:block>
        
        <fo:block space-after="6pt">
            <fo:block>
                <xsl:if test="Psexo ='F'">Señora</xsl:if>
                <xsl:if test="Psexo!='F'">Señor</xsl:if>
            </fo:block><fo:block>
                <xsl:value-of select="Pnombre" 
                    /> <xsl:value-of select="Papellido1"
                    /> <xsl:value-of select="Papellido2" />
            </fo:block><fo:block>
                <xsl:value-of select="Roldescripcion" />
            </fo:block><fo:block space-after="15pt">
                Presente
            </fo:block><fo:block space-after="6pt">
                Apreciado(a) <xsl:value-of select="Roldescripcion" />
            </fo:block>
			
			<xsl:if test="rol != 'edu.encargado'">
			<fo:block space-after="6pt">
                Felicitaciones!!! A partir de este momento Ud. forma parte de la 
                Comunidad Digital de <xsl:value-of select="CEnombre" /> a través del Portal 
                <fo:inline text-decoration="underline">www.migestion.net </fo:inline>
                en el cual de ahora en adelante podrá:                
            </fo:block>
			</xsl:if>
			
			<xsl:if test="rol = 'edu.encargado'">
			<fo:block space-after="6pt">
                Felicitaciones!!! A partir de este momento Ud. y su(s) hijo(a)(s) forman parte de la 
                Comunidad Digital de <xsl:value-of select="CEnombre" /> a través del Portal 
                <fo:inline text-decoration="underline">www.migestion.net </fo:inline>
                en el cual de ahora en adelante, al activar su cuenta, podrá:                
            </fo:block>
			</xsl:if>
			
			<fo:block space-after="6pt"  font-weight="bold" >
                <xsl:value-of select="//roles/rol[rol=current()/rol]/Rolinfo" disable-output-escaping="yes" />
            </fo:block><fo:block space-after="6pt">
                Todo esto, las 24 horas del día, los 365 días de año y desde cualquier lugar por Internet!!!
            </fo:block><fo:block space-after="4pt">
                Es muy fácil. Para activar su cuenta, solamente siga estos <fo:inline font-weight="bold">4 PASOS</fo:inline>:
            </fo:block><fo:block space-after="6pt">
                <fo:table>
                    <fo:table-column column-width="0.25in" />
                    <fo:table-column column-width="6.25in" />
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell><fo:block>1.</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>
                                <fo:inline text-decoration="underline" font-weight="bold" >Firme y entregue. </fo:inline>
                                Por favor regrese la copia de esta comunicación firmada a la Institución dentro de los
                                <fo:inline font-weight="bold">3 días siguientes</fo:inline> al recibo de la misma o 
                                envíela lo más pronto posible por fax al número: 204-7156, para habilitar su 
                                ingreso al Portal.
                            </fo:block></fo:table-cell>
                        </fo:table-row><fo:table-row>
                            <fo:table-cell><fo:block>2.</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>
                                <fo:inline text-decoration="underline" font-weight="bold" >Guarde su usuario temporal. </fo:inline>
                                Su usuario temporal es:
                                <fo:inline font-weight="bold">
                                    <xsl:if test="$copia='usuario'">
                                        <xsl:value-of select="Usueplogin" />
                                    </xsl:if>
                                    <xsl:if test="$copia!='usuario'">
                                        XXXXXXXXX
                                    </xsl:if>
                                </fo:inline>.
                            </fo:block></fo:table-cell>
                        </fo:table-row><fo:table-row>
                            <fo:table-cell><fo:block>3.</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>
                                <fo:inline text-decoration="underline" font-weight="bold" >Reciba su contraseña temporal. </fo:inline>
                                Una vez que recibamos la copia de esta carta, le estaremos enviando su 
                                contraseña temporal a través del correo electrónico suministrado por usted.
                            </fo:block></fo:table-cell>
                        </fo:table-row><fo:table-row>
                            <fo:table-cell><fo:block>3.</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>
                                <fo:inline text-decoration="underline" font-weight="bold" >Ingrese al Portal y actívese. </fo:inline>
                                Con la identificación de usuario y contraseña TEMPORALES recibidas, ingrese a 
                                <fo:inline text-decoration="underline">www.migestion.net </fo:inline>
                                y siga las instrucciones sugeridas por el sistema.
                            </fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
			
			<xsl:if test="rol = 'edu.encargado'">
			<fo:block space-after="6pt">
                Es importante que cambie su identificación de usuario y contraseña TEMPORALES por una permanente.
                Esto garantizará la personalización y confidencialidad de su información.
                Solamente siga las instrucciones del sistema en línea. Adicionalmente, dentro de este proceso 
                de afiliación, usted también podrá darle acceso al Portal a su(s) hijo(a)(s) menor(es) a 
                través de la opción que aparece en pantalla.
            </fo:block>
			</xsl:if>
			
			<xsl:if test="rol != 'edu.encargado'">
			<fo:block space-after="6pt">
                Es importante que cambie su identificación de usuario y contraseña TEMPORALES por una permanente.
                Esto garantizará la personalización y confidencialidad de su información.
                Solamente siga las instrucciones del sistema en línea. 
            </fo:block>
			</xsl:if>
						
			<fo:block space-after="6pt">
                Para mayor información, contáctenos en <fo:inline text-decoration="underline">gestion@soin.co.cr</fo:inline>
                o al tel. 204-7151
            </fo:block><fo:block space-after="30pt">
                Cordialmente,
            </fo:block><fo:block>
            
            </fo:block>
            
            
            <fo:table>
                <fo:table-column column-width="2.0in" />
                <fo:table-column column-width="5.0in" />
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
        
                            <fo:block>
                                <fo:block>
                                    <fo:leader leader-pattern="rule" rule-style="solid"  leader-length="2in" />
                                </fo:block>
                                <xsl:if test="$AdminNombre">
                                    <fo:block>
                                        <xsl:value-of select="$AdminNombre" />
                                    </fo:block>
                                </xsl:if>
                                <fo:block>
                                    <xsl:value-of select="$AdminRol" />
                                </fo:block>
                            </fo:block>
            
            
                        </fo:table-cell>
                        <xsl:if test="$copia='portal'">
                            <fo:table-cell><fo:block text-align="right">
                                <fo:block>
                                    Nombre: <xsl:value-of select="Pnombre" 
                                        /> <xsl:value-of select="Papellido1"
                                        /> <xsl:value-of select="Papellido2" />
                                </fo:block><fo:block>
                                    Recibí conforme</fo:block><fo:block>
                                    Firma: <fo:leader leader-pattern="rule" rule-style="solid"  leader-length="2in" />.
                                </fo:block><fo:block>
                                    Fecha: <fo:leader leader-pattern="rule" rule-style="solid"  leader-length="2in" />.
                                </fo:block>
                            </fo:block></fo:table-cell>
                        </xsl:if>
                    </fo:table-row>
                    <fo:table-row>
                        <xsl:if test="$copia='portal'">
                            <fo:table-cell number-columns-spanned="2"><fo:block text-align="right">
                                <fo:block>
                                    Correo electrónico: 
                                    <fo:leader leader-pattern="rule" rule-style="solid"  leader-length="2in" />.
                                </fo:block><fo:block>
                                    Si ya tiene un usuario activo en
                                    <fo:inline text-decoration="underline">www.migestion.net</fo:inline>
                                    escríbalo:
                                    <fo:leader leader-pattern="rule" rule-style="solid"  leader-length="2in" />.
                                </fo:block>
                            </fo:block></fo:table-cell>
                        </xsl:if>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            
            <xsl:if test="$copia='portal'">
				<xsl:if test="rol = 'edu.encargado'">
					<fo:table width="100%">
						<fo:table-column column-width="1.75in" />
						<fo:table-column column-width="1.75in" />
						<fo:table-column column-width="1.75in" />
						<fo:table-column column-width="1.75in" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell number-columns-spanned="4">
									<fo:block>
										<fo:leader leader-pattern="rule" rule-style="double" rule-thickness="2.0pt" leader-length="auto" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell number-columns-spanned="4">
									<fo:block>
										<fo:inline text-decoration="underline">AUTORIZACION DE HIJOS</fo:inline>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell number-columns-spanned="4">
									<fo:block space-before="5pt">
										Autorizo a mi(s) hijo(s) para afiliarse al portal:
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-size="10pt"><fo:inline font-weight="bold">NOMBRE</fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block font-size="10pt"><fo:inline font-weight="bold">GRADO</fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block font-size="10pt"><fo:inline font-weight="bold">EMAIL</fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block font-size="10pt"><fo:inline font-weight="bold">FIRMA ENCARGADO</fo:inline></fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block><fo:inline font-weight="bold"><fo:leader leader-pattern="rule" rule-style="solid" leader-length="1.6in" /></fo:inline></fo:block>
	
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell number-columns-spanned="4">
									<fo:block font-size="7pt">
										Con esta autorización le será entregado a usted el NOMBRE DE USUARIO TEMPORAL y al correo electrónico de su hijo la CONTRASEÑA TEMPORAL con el fin de que ellos puedan ingresar al portal con su propio usuario. Si su hijo no tiene correo electrónico, por favor escriba una dirección de correo electrónico donde pueda recibirlo.
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</xsl:if>

                <fo:block text-align="left" space-before="10pt" >
                    [ COPIA - INSTITUCION ] FAVOR REGRESAR ESTE FORMULARIO
                </fo:block>
            </xsl:if>
            <xsl:if test="$copia='usuario'">
                <fo:block text-align="left" space-before="10pt" >
                    [ ORIGINAL - USUARIO ] CONSERVE ESTE DOCUMENTO
                </fo:block>
            </xsl:if>

        </fo:block>
    </fo:block>
</xsl:template>

<!-- esto estaba en resumen.xsl -->
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

</xsl:stylesheet>