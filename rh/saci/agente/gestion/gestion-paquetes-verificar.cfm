<!---selecciona los servicios inconsistentes(que no son aceptados por el nuevo paquete que se desea cambiar)--->
<cfquery name="rsServiciosIncons" datasource="#session.DSN#">
	select b.LGnumero, b.LGlogin, e.TScodigo
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.PQcodigo=a.PQcodigo
			and c.TScodigo in(select x.TScodigo from ISBservicioTipo x where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			and c.TScodigo in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#ListVerificar#">)
			and c.Habilitado=1
		inner join ISBservicio e
			on e.PQcodigo=c.PQcodigo
			and e.TScodigo=c.TScodigo
			and e.Habilitado =1		
	where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
	and a.CTcondicion = '1' 	
</cfquery>
<cfquery name="rsPQanterior" datasource="#session.DSN#">
	select PQnombre
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	and Habilitado=1
</cfquery>
<cfquery name="rsPQnuevo" datasource="#session.DSN#">
	select PQnombre
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
	and Habilitado=1
</cfquery>

<cfoutput>
<form name="form1" method="post" style="margin: 0;" action="gestion.cfm" onsubmit="javascript: return validar(this);">
	<cfinclude template="gestion-hiddens.cfm">
	<input type="hidden" name="CTid" value="#form.CTid#" />
	<input type="hidden" name="Contratoid" value="#session.saci.cambioPQ.contrato#" />
	<input type="hidden" name="PQcodigo2" value="#session.saci.cambioPQ.PQnuevo#" />
	<input type="hidden" name="ListVerificar" value="#ListVerificar#" />
	<input type="hidden" name="verificar2" value="1" />
	<table  width="100%"border="0" cellpadding="0" cellspacing="0">
		<tr class="tituloAlterno" align="center"><td colspan="6">Lista de servicios Inconsitentes por login</td></tr>
		<tr class="tituloAlterno">
			<td>Login</td>
			<td>Servicio</td>
			<td>Mantener</td>
			<td>Descartar</td>
			<td colspan="2">Paquete Nuevo</td>
			<!--- <td>&nbsp;</td>  --->
		</tr>
		<cfif rsServiciosIncons.recordCount GT 0>
			<cfloop query="rsServiciosIncons">
			<cfset nom = "_"&rsServiciosIncons.LGnumero&"_"&rsServiciosIncons.TScodigo>
			<tr><td>#rsServiciosIncons.LGlogin#</td>
				<td>#rsServiciosIncons.TScodigo#</td>
				<td align="center"><input  name="r#nom#" id="r#nom#" type="radio" value="1"/><!--- <label for="r1#nom#">Mantener</label> ---></td>
				<td align="center"><input name="r#nom#" id="r#nom#" type="radio" value="2"/><!--- <label for="r2#nom#">Descartar</label> ---></td>
				<td align="right"><input name="r#nom#" id="r#nom#" type="radio" value="3"/><!--- <label for="r3#nom#">PaqueteNuevo</label> ---></td>
				<td>
					<table width="100%"border="0" cellpadding="1" cellspacing="0"><tr id="PAQ"><td>
						<cf_paquete 
						sufijo = "#nom#"
						agente = ""
						form = "form1"
						Ecodigo = "#session.Ecodigo#"
						Conexion = "#session.DSN#"
						readOnly = "false"
						sizeCod = "5"
						sizeDes = "20"
						idCambioPaquete="#session.saci.cambioPQ.PQanterior#"
					>
					</td></tr></table>
				</td>
			</tr>
			</cfloop>
		</cfif>
		<tr><td align="right" colspan="6">
		 	<cf_botones names="Verificar" values="Verificar">
		</td></tr>
		<cfif isdefined("form.verificar2")>
		<tr align="center"><td colspan="6">
			<table  width="95%"border="0" cellpadding="2" cellspacing="0">
				<tr><td>
				<strong><font color="##660000">
					Los servicios en la parte superior causan conflicto con el nuevo paquete, 
					puede elegir mantener uno de los servicios que se repiten, pero 
					debe descartar o reubicar en otro paquete el otro servicio.
				</font></strong>
				</td></tr>
			</table>
		</td></tr>
		</cfif>
	</table>
</form>

<script type="text/javascript">
	<!-- Validación de los paquetes--->
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';

		<cfif rsServiciosIncons.recordCount GT 0>
			<cfloop query="rsServiciosIncons">
				<cfset nom = "_"&rsServiciosIncons.LGnumero&"_"&rsServiciosIncons.TScodigo>
				if (formulario.r#nom#[2].checked)
				{
					if (formulario.PQcodigo#nom#.value == "") {
						error_msg += "\n - El codigo de Paquete para el Login #rsServiciosIncons.LGlogin# no puede quedar en blanco.";
						error_input = formulario.PQcodigo#nom#;
					}	
				}
			</cfloop>
		</cfif>
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
	}
</script>
</cfoutput>
	 