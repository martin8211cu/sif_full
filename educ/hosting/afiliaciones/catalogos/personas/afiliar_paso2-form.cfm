<cfparam name="url.id_persona" type="numeric">
<cfparam name="url.programa">
<cfset id_programa = ListFirst(url.programa)>
<cfset id_vigencia = ListLast(url.programa)>

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
</cfquery>


<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.periodicidad, v.tipo_periodo,
		v.fecha_desde, v.fecha_hasta, v.cantidad_carnes, v.generar_carnes
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
</cfquery>

<cfquery datasource="#session.dsn#" name="sa_entrada">
	select e.codigo_barras, e.fila, e.asiento
	from sa_entrada e
	where e.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and e.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and e.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
</cfquery>

<cfoutput>
	
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_personas.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
	//-->
	</script>
	
	<!--- sintaxis de ../personas/ para que se pueda invocar desde ../programas/ --->
	<form action="../personas/afiliar_paso3.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
			<table width="559" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
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
				<tr>
				  <td align="left" nowrap>Programa</td>
				  <td colspan="3" valign="top">#progs.nombre_programa# #progs.nombre_vigencia#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Periodo</td>
				  <td colspan="3" valign="top">#DateFormat(progs.fecha_desde,'dd/mm/yyyy')# - #DateFormat(progs.fecha_hasta,'dd/mm/yyyy')#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Costo</td>
				  <td colspan="3" valign="top">#NumberFormat(progs.costo,',0.00')#                      <cfif progs.tipo_periodo is 'U'>
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
</cfif>				  </td>
</tr>
                <tr>
                  <td align="left">Carn&eacute;s / Entradas </td>
                  <td colspan="3" align="left">
				  <cfif progs.generar_carnes>
				  #progs.cantidad_carnes#
				  <cfelse>No se utilizan
				  </cfif></td>
                </tr><cfif progs.generar_carnes and progs.cantidad_carnes><tr>
			  <td colspan="4" class="subTitulo">
			Asignar Carn&eacute;s </td>
			  </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td width="50" align="left">Fila</td>
                  <td width="50" align="left">Asiento</td>
                  <td width="291" align="left">&nbsp;</td>
                </tr>
				
				<cfloop query="sa_entrada">
                <tr>
                  <td align="left">Carnet Numero #sa_entrada.CurrentRow# </td>
                  <td align="left"><input type="text" maxlength="5" size="5" name="fila#sa_entrada.CurrentRow#" id="fila#sa_entrada.CurrentRow#" value="#HTMLEditFormat(sa_entrada.fila)#" onchange="this.value=this.value.toUpperCase()" ></td>
                  <td align="left"><input type="text" maxlength="5" size="5" name="asiento#sa_entrada.CurrentRow#" id="asiento#sa_entrada.CurrentRow#" value="#HTMLEditFormat(sa_entrada.asiento)#" onchange="this.value=this.value.toUpperCase()"></td>
                  <td align="left">Asignada</td>
                </tr></cfloop>
				<cfif sa_entrada.RecordCount  LT progs.cantidad_carnes>
					<cfloop from="#sa_entrada.RecordCount + 1#" to="#progs.cantidad_carnes#" index="i">
					<tr>
					  <td align="left">Carnet Numero #i# </td>
					  <td align="left"><input type="text" maxlength="5" size="5" name="fila#i#" id="fila#i#" value="" onchange="this.value=this.value.toUpperCase()" ></td>
					  <td align="left"><input type="text" maxlength="5" size="5" name="asiento#i#" id="asiento#i#" value="" onchange="this.value=this.value.toUpperCase()"></td>
					  <td align="left">&nbsp;</td>
					</tr></cfloop>
				</cfif>
				</cfif>
              <tr>
<td colspan="4" align="left">&nbsp;</td>
</tr>


<tr><td colspan="4" class="formButtons">
<input type="button" name="btnRegresar"  value="&lt; &lt; Regresar" onClick="funcRegresar()">
<input type="submit" name="btnSiguiente" value="Realizar afiliación &gt;&gt;">
</td></tr>
</table>
<input type="hidden" name="id_persona"  value="#HTMLEditFormat(data.id_persona)#">
<input type="hidden" name="id_programa" value="#HTMLEditFormat(id_programa)#">
<input type="hidden" name="id_vigencia" value="#HTMLEditFormat(id_vigencia)#">
<cfparam name="url.back_prog" default="">
<input type="hidden" name="back_prog" value="#HTMLEditFormat(url.back_prog)#">
</form>
</cfoutput>	
