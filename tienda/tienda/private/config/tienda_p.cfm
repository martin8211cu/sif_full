<cfif NOT IsDefined("session.Ecodigo")>
	<cflocation url="/">
</cfif>
<cfset modo="Cambio">
<cfquery name="arte" datasource="#Session.DSN#">
	select *
	from ArteTienda
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>


<form action="tienda_go.cfm" method="post" enctype="multipart/form-data" name="form1" onSubmit="" onReset="">

	<table width="946" align="center" cellpadding="0" cellspacing="0">
		<tr align="center"><td colspan="2" nowrap class="tituloListas"><b>Tienda</b></td></tr>
	
		<tr>
			<!--- DATOS --->
			<td width="822" valign="top">
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr align="left" valign="top">
						<td nowrap>Nombre</td>
						<td >Fuente de letra</td>
						<td width="22%">&nbsp;</td>
					</tr>	
					
					<tr>
						<td width="36%" ><input name="nombre_tienda" onFocus="this.select()" type="text" tabindex="1" value="<cfoutput>#session.Enombre#</cfoutput>" size="50" maxlength="80"  alt="El nombre de la tienda"></td>
						<td width="42%" >
							<cfset validfonts = "">
							<cfset validfonts = ListAppend(validfonts, "Arial, Helvetica, sans-serif", ";")>
							<cfset validfonts = ListAppend(validfonts, "Times New Roman, Times, serif", ";")>
							<cfset validfonts = ListAppend(validfonts, "Courier New, Courier, mono", ";")>
							<cfset validfonts = ListAppend(validfonts, "Georgia, Times New Roman, Times, serif", ";")>
							<cfset validfonts = ListAppend(validfonts, "Verdana, Arial, Helvetica, sans-serif", ";")>
							<cfset validfonts = ListAppend(validfonts, "Geneva, Arial, Helvetica, sans-serif", ";")>

							<select name="font" tabindex="5" >
								<option value="" <cfif Len(Trim(arte.font)) EQ 0>checked</cfif> >Predeterminada</option>
								<cfloop index="i" from="1" to="#ListLen(validfonts,';')#">
									<cfoutput>
									<option value="#ListGetAt(validfonts, i, ';')#" <cfif arte.font EQ ListGetAt(validfonts, i, ';')>selected</cfif> >
										#ListGetAt(validfonts, i, ';')#</option>
									</cfoutput>
								</cfloop>
							</select> 
						</td>
						<td align="center"></td>
						
					</tr>

					<tr>
					  <td nowrap>Correo electr&oacute;nico para servicio a clientes </td>
					  <td nowrap>Logotipo</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td nowrap><input name="correo_clientes" onFocus="this.select()" type="text" tabindex="2" value="<cfoutput>#arte.correo_clientes#</cfoutput>" size="50" maxlength="80"  alt="Correo electrónico utilizado para atenci&oacute;n a clientes"></td>
					  <td nowrap><input type="file" name="logo" size="50" tabindex="6" onChange="document.getElementById('img_logotipo').src = this.value;" ></td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
						<td nowrap>&nbsp; </td>
						<td nowrap>Texto al pie de la imagen</td>
						<td>&nbsp;</td>
					</tr>

					<tr align="left" valign="top">
						<td>						<td colspan="2" rowspan="4">
							<textarea cols="60" tabindex="7" rows="4" name="txt_pie_foto" style="width:95% " wrap="soft"><cfoutput>#Trim(arte.txt_pie_foto)#</cfoutput></textarea>
						</td>
					</tr>
					<tr align="left" valign="top">
					  <td><input type="checkbox" tabindex="3" <cfif modo neq 'ALTA' and arte.agregar_uno eq 1>checked</cfif> name="agregar_uno">Agregaci&oacute;n r&aacute;pida</td>
				  </tr>
					<tr align="left" valign="top">
					  <td><input type="radio" tabindex="4" value="C" name="tipo_vista" <cfif modo eq 'ALTA' or arte.tipo_vista eq 'C'>checked</cfif>>
				      Mostrar categor&iacute;as en el cat&aacute;logo </td>
				  </tr>
					<tr align="left" valign="top">
					  <td><input type="radio" tabindex="4" value="M" name="tipo_vista" <cfif modo neq 'ALTA' and arte.tipo_vista eq 'M'>checked</cfif>>
					    Mostrar cat&aacute;logo como men&uacute; </td>
				  </tr>

				</table>
			</td>
			
			<!--- IMAGEN --->
			<td width="122">
				<img src="../../public/tienda_img.cfm?id=<cfoutput>#session.Ecodigo#</cfoutput>" alt="" name="img_logotipo" height="120" border="1" id="img_logotipo" >
			</td>
		</tr>
	
		<tr>
		  <td>&nbsp;</td>
	  <td rowspan="2">&nbsp;</td></tr>
		<tr>
		  <td>&nbsp;</td>
	  </tr>
		<tr><td>&nbsp;</td><td>&nbsp;</td></tr>		

		<tr align="center" valign="top"><td colspan="2">
			<input name="submit" type="submit" value="Guardar" tabindex="8">
		</td></tr>
		<tr align="center" valign="top"><td colspan="2">&nbsp;</td></tr>		
	</table>

</form>
