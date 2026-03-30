<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
	  	<td style="text-align:justify">
			Especificar direcciones de correo adicionales donde 
			usted desea reenviar autom&aacute;ticamente copias de sus correos.
		</td>
	  </tr>
	  <tr>
	  	<td>
			<cf_web_portlet_start tipo="Box">
				<cfif LoginBloqueado>
					<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
					</table>
				<cfelseif not ExisteMail>
					<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td align="center"><label style="color:##660000">#mensArr[14]#</label></td></tr>
					</table>
				<cfelse>
					<table class="cfmenu_menu" width="100%" border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td align="right">
							<label><cf_traducir key="email">Correo Electr&oacute;nico</cf_traducir></label>
						</td>
						<td>
							<input name="LGmailFor#Attributes.sufijo#" id="LGmailFor#Attributes.sufijo#" type="text" 
							value="" size="40" maxlength="255" tabindex="1" onfocus="this.select()" 
							onblur="if(!validateEmail(this))alert('Formato de e-mail incorrecto');" >
						</td>
						<td width="1">
							<cf_botones names="Agregar" values="Agregar" tabindex="1">
						</td>
					  </tr>
					</table>
				</cfif>
			<cf_web_portlet_end> 
		
		</td>
	  </tr>
	  <cfif not LoginBloqueado and ExisteMail>
		  <tr>
			<td>
				<cfinvoke 
				 component="sif.Componentes.pListas" 
				 method="pLista">
					<cfinvokeargument name="tabla" value="ISBmailForward a
															inner join ISBlogin b
																on b.LGnumero = a.LGnumero
															inner join ISBproducto c
																on c.Contratoid = b.Contratoid
															inner join ISBcuenta d
																on d.CTid = c.CTid"/>
					<cfinvokeargument name="columnas" value="d.Pquien as Cliente, c.CTid, c.Contratoid, b.LGnumero, a.LGmailForward ,
															   0 as Baja,
															   '<a href=''javascript: EliminarForward(""' || rtrim(a.LGmailForward) || '"");''><img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0''></a>' as imag"/>
					<cfinvokeargument name="desplegar" value="LGmailForward, imag"/>
					<cfinvokeargument name="etiquetas" value="Lista de Direcciones Forward, &nbsp;"/>
					<cfinvokeargument name="filtro" value="a.LGnumero = #Attributes.idlogin#
														   order by a.LGnumero, a.LGmailForward"/>
					<cfinvokeargument name="align" value="left,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#Attributes.forwardIra#"/>
					<cfinvokeargument name="formName" value="#Attributes.form#"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="mostrar_filtro" value="false"/>
					<cfinvokeargument name="filtrar_automatico" value="false"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="maxrows" value="0"/>
				</cfinvoke>
			</td>
		  </tr>
	  </cfif>
	</table>

<script language="javascript" type="text/javascript">
	function EliminarForward(mail)
	{
		if (confirm("Desea eliminar la dirección de correo forward?")) 
		{
			document.#Attributes.form#.BAJA.value = '1';
			document.#Attributes.form#.LGMAILFORWARD.value = mail;
			document.#Attributes.form#.submit();
			return false;
		}
	}

	function isValidEmail(e)
	{
		// assume an email address cannot start with an @ or white space, but it
		// must contain the @ character followed by groups of alphanumerics and '-'
		// followed by the dot character '.'
		// It must end with 2 or 3 alphanumerics.
		//
		var alnum="a-zA-Z0-9";
		exp="^[^@\\s]+@(["+alnum+"+\\-]+\\.)+["+alnum+"]["+alnum+"]["+alnum+"]?$";
		emailregexp = new RegExp(exp);
	
		result = e.match(emailregexp);
		if (result != null)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	
	function validateEmail(obj)
	{
		return isValidEmail(obj.value);
	}	
	
	
</script>

</cfoutput>