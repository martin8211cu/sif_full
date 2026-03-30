<cfif isdefined("Form.PRJid") and Len(Trim(Form.PRJid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfquery name="rsPRJparametros" datasource="#Session.DSN#">
	select PCElongitud
	from PRJparametros p, PCECatalogo c
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and c.PCEcatid = p.PCEcatidProyecto
</cfquery>

<cfif rsPRJparametros.PCElongitud gt 10>
	<cfset rsPRJparametros.PCElongitud = 10>
</cfif>

<cfquery name="rsTiposProyectos" datasource="#Session.DSN#">
	select PRJTid, PRJTdescripcion
	from PRJTiposProyectos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by PRJTdescripcion
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsProyecto" datasource="#Session.DSN#">
		select a.PRJid, a.PRJcodigo, a.PRJdescripcion, a.PRJestado, a.Cmayor, a.PRJTid, a.PRJfechaInicio, a.Mcodigo, a.ts_rversion,
			   b.Cdescripcion, c.SNcodigo, c.SNnumero, c.SNidentificacion, c.SNnombre, d.Mnombre, 
			   datalength (a.PRJarchivo) as hay_archivo
		from PRJproyecto a, CtasMayor b, SNegocios c, Monedas d
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJid#">
		and a.Ecodigo = b.Ecodigo
		and a.Cmayor = b.Cmayor
		and a.Ecodigo *= c.Ecodigo
		and a.SNcodigo *= c.SNcodigo
		and a.Ecodigo = d.Ecodigo
		and a.Mcodigo = d.Mcodigo
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisCuentas() {
		var w = 500;
		var h = 350;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("ConlisCuentas.cfm?form=form1",l,t,w,h);
	}
	
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td valign="top" width="40%">
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="PRJproyecto a"/>
		  <cfinvokeargument name="columnas" value="a.PRJid, a.PRJcodigo, a.PRJdescripcion, a.PRJestado, a.Cmayor, a.PCEMid, a.PCNidActividad"/>
		  <cfinvokeargument name="desplegar" value="PRJcodigo, PRJdescripcion"/>
		  <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
		  <cfinvokeargument name="formatos" value="V, V, V"/>
		  <cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
		  										 order by a.PRJcodigo, a.PRJdescripcion"/>
		  <cfinvokeargument name="align" value="left, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJid"/>
		  <cfinvokeargument name="irA" value="Proyectos.cfm"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="Proyectos-sql.cfm">
		  <cfif modo EQ "CAMBIO">
		  	<input type="hidden" name="PRJid" value="#Form.PRJid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>Tipo de Proyecto:</td>
			  <td>
			  	<select name="PRJTid">
			  	<cfloop query="rsTiposProyectos">
					<option value="#rsTiposProyectos.PRJTid#" <cfif modo EQ 'CAMBIO' and rsTiposProyectos.PRJTid EQ rsProyecto.PRJTid> selected</cfif>>#rsTiposProyectos.PRJTdescripcion#</option>
				</cfloop>
				</select>
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>C&oacute;digo:</td>
			  <td>
			  	 <input name="PRJcodigo" type="text" id="PRJcodigo" size="#rsPRJparametros.PCElongitud#" maxlength="#rsPRJparametros.PCElongitud#" value="<cfif modo EQ 'CAMBIO'>#rsProyecto.PRJcodigo#</cfif>" 
				 	onBlur="var n = this.value.length + 10; this.value = ('0000000000' + this.value).substring(n - #rsPRJparametros.PCElongitud#)"
				 >
				 <cfif modo EQ "CAMBIO">
			  	 <input name="PRJcodigo_ant" type="hidden" id="PRJcodigo_ant" value="#rsProyecto.PRJcodigo#">
				 </cfif>
			  </td>
			</tr>
			<tr>
              <td align="right" nowrap>Descripci&oacute;n:</td>
              <td>
			  	<input name="PRJdescripcion" type="text" id="PRJdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsProyecto.PRJdescripcion#</cfif>">
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>Fecha de Inicio:</td>
			  <td>
			  	<cfif modo EQ "CAMBIO">
					<cfset fechainicio = LSDateFormat(rsProyecto.PRJfechaInicio, 'dd/mm/yyyy')>
				<cfelse>
					<cfset fechainicio = "">
				</cfif>
			  	<cf_sifcalendario form="form1" name="PRJfechaInicio" value="#fechainicio#">
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>Cuenta Mayor: </td>
			  <td>
			  	<cfif modo EQ "CAMBIO">
					<input name="Cmayor" type="text" id="Cmayor" size="6" maxlength="4" value="<cfif modo EQ 'CAMBIO'>#rsProyecto.CMayor#</cfif>" readonly>
					<input type="text" name="Cdescripcion" id="Cdescripcion"  value="<cfif modo EQ 'CAMBIO'>#rsProyecto.Cdescripcion#</cfif>" size="40" readonly>
				<cfelse>
					<input name="Cmayor" type="text" id="Cmayor" size="6" maxlength="4" readonly>
					<input type="text" name="Cdescripcion" id="Cdescripcion" size="40" readonly>
					<a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentas();"></a>
					<input type="hidden" name="PCEMid" id="PCEMid" value="<cfif modo EQ 'CAMBIO'>#rsProyecto.PCEMid#</cfif>">
				</cfif>
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>Socios de Negocio: </td>
			  <td>
			  	<cfif modo EQ 'CAMBIO'>
					<cf_sifsociosnegociosFA form="form1" query="#rsProyecto#">
				<cfelse>
					<cf_sifsociosnegociosFA form="form1">
				</cfif>
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>Moneda:</td>
			  <td>
			    <cfif modo EQ 'ALTA'>
					<select name="Mcodigo">
					<cfloop query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#" <cfif modo EQ 'CAMBIO' and rsMonedas.Mcodigo EQ rsProyecto.Mcodigo> selected</cfif>>#rsMonedas.Mnombre#</option>
					</cfloop>
					</select>
				<cfelse>
					#rsProyecto.Mnombre#
				</cfif>
			  </td>
		    </tr>
			<tr>
              <td align="right" nowrap>Estado:</td>
              <td><select name="PRJestado" id="PRJestado">
                  <option value="0" <cfif modo EQ 'CAMBIO' and rsProyecto.PRJestado EQ 0> selected</cfif>>Inactivo</option>
                  <option value="1" <cfif modo EQ 'CAMBIO' and rsProyecto.PRJestado EQ 1> selected</cfif>>Activo</option>
                  <option value="2" <cfif modo EQ 'CAMBIO' and rsProyecto.PRJestado EQ 2> selected</cfif>>Cerrado</option>
              </select></td>
		    </tr>
			<tr>
			  <td align="right" nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsProyecto.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
			  	<cfinclude template="/sif/portlets/pBotones.cfm">
				<cfif modo neq 'ALTA'>
				<cfif rsProyecto.PRJestado LT 2>
				<input type="button" name="detalle" value="Actividades" onClick="location.href='Actividades.cfm?PRJid=#HTMLEditFormat(form.PRJid)#'">
				</cfif>
				<cfif rsProyecto.hay_archivo>
				<input type="button" name="download" value="Ir a Microsoft Project" onClick="location.href='Proyectos-download.cfm?PRJid=#HTMLEditFormat(form.PRJid)#'">
				</cfif>
				</cfif>
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.PRJTid.required = true;
	objForm.PRJTid.description = "Tipo de Proyecto";
	objForm.PRJcodigo.required = true;
	objForm.PRJcodigo.description = "Código";
	objForm.PRJdescripcion.required = true;
	objForm.PRJdescripcion.description = "Descripción";
	objForm.PRJfechaInicio.required = true;
	objForm.PRJfechaInicio.description = "Fecha de Inicio";
	objForm.Cmayor.required = true;
	objForm.Cmayor.description = "Cuenta Mayor";
	<cfif modo EQ 'ALTA'>
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	</cfif>
</script>
