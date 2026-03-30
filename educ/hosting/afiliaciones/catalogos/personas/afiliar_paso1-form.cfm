<cfparam name="url.id_persona" type="numeric">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
</cfquery>


<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.moneda, v.periodicidad, v.tipo_periodo,
		v.fecha_desde, v.fecha_hasta
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and not exists (
	  	select *
		from sa_afiliaciones a
		where a.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
		  and a.id_programa = p.id_programa
		  and a.id_programa = v.id_programa
		  and a.id_vigencia = v.id_vigencia )
</cfquery>

<cfoutput>
	
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_personas.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
	//-->
	</script>
	
	<form action="afiliar_paso2.cfm" onsubmit="return validar(this);" method="get" name="form1" id="form1">
			<table width="610" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Afiliar a un Programa </td>
			  </tr>
				<tr><td width="140" valign="top">Nombre
				</td>
				  <td colspan="3" valign="top">#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#</td>
			    </tr>
				<tr>
				  <td valign="top">Correo Electr&oacute;nico </td>
				  <td colspan="3" valign="top">#HTMLEditFormat(data.Pemail1)#                  </td>
			  </tr>
				<tr><td valign="top">C&eacute;dula</td>
				  <td colspan="3" valign="top">#HTMLEditFormat(data.Pid)#</td>
			    </tr>
				<tr><td colspan="4" align="left" nowrap>&nbsp; </td>
			    </tr>
				
			    <tr>
			      <td colspan="4" align="left" class="subTitulo">Seleccione el programa al cual desea afiliar a esta persona </td>
		      </tr>
			    <tr>
			      <td colspan="4" align="left"><table width="100%"  border="0" cellpadding="0" cellspacing="0">
			    <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">Programa</td>
                  <td align="right">Costo</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>Periodo</td>
			    </tr>
               <cfloop query="progs">
               <tr>
                      <td><input name="programa" id="programa_#progs.id_programa#_#progs.id_vigencia#" type="radio" value="#progs.id_programa#,#progs.id_vigencia#" <cfif progs.CurrentRow is 1>checked</cfif>>
                        </td>
                  <td><label for="programa_#progs.id_programa#_#progs.id_vigencia#" >#progs.nombre_programa#</label></td>
                  <td><label for="programa_#progs.id_programa#_#progs.id_vigencia#" >#progs.nombre_vigencia#</label></td>
                    <td align="right"><label for="programa_#progs.id_programa#_#progs.id_vigencia#" >
					#NumberFormat(progs.costo,',0.00')#
					#progs.moneda#
					</label>
					</td>
                    <td align="right">&nbsp;</td>
                    <td><label for="programa_#progs.id_programa#_#progs.id_vigencia#" >
					<cfif progs.tipo_periodo is 'U'>
						Pago &Uacute;nico
					<cfelseif progs.tipo_periodo is 'S'>
						<cfif progs.periodicidad is 1>
							Cada Semana
						<cfelse>
							Cada #progs.periodicidad# Semanas
						</cfif>
					<cfelseif progs.tipo_periodo is 'S'>
						<cfif progs.periodicidad is 1>
							Cada Mes
						<cfelse>
							Cada #progs.periodicidad# Meses
						</cfif>
					</cfif></label></td>
                    <td><label for="programa_#progs.id_programa#_#progs.id_vigencia#" >#DateFormat(progs.fecha_desde,'dd/mm/yyyy')# - #DateFormat(progs.fecha_hasta,'dd/mm/yyyy')#</label></td>
               </tr>
			  </cfloop>
                  </table></td>
		      </tr>
		      <tr>
      <td align="left">&nbsp;</td>
      <td colspan="3" valign="top">&nbsp;
      </td>
        </tr> 
	
			
			<tr><td colspan="4" class="formButtons">
				<input type="button" name="btnRegresar" value="&lt;&lt; Regresar" onClick="funcRegresar()">
				<input type="submit" name="btnSiguiente" value="Continuar &gt;&gt;">
			</td></tr>
	  </table>
					<input type="hidden" name="id_persona" value="#HTMLEditFormat(data.id_persona)#">
				
</form>


</cfoutput>	
