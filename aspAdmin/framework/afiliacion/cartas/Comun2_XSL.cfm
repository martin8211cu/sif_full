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
