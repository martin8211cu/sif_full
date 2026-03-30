<cfquery name="rsDatos" datasource="#session.DSN#">
	select	a.TScodigo,a.TSnombre, a.TSobservacion,
			b.PQinterfaz as ci,
			coalesce(b.SVcantidad,0) as cc,
			b.Habilitado as ch,
			coalesce(a.TStipo,'N') as TStipo
	from 	ISBservicioTipo a
			left outer join ISBservicio b
				on b.TScodigo=a.TScodigo 
				and b.PQcodigo = <cfqueryparam value="#Form.PQcodigo#" cfsqltype="cf_sql_char">
	where	a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Habilitado=1
</cfquery>

<cfoutput>


<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="mostrarser">
	<cfinvokeargument name="Pcodigo" value="224">
</cfinvoke>

<cfset mostrar_servicio = false>

<cfif mostrarser eq "SI">
	<cfset mostrar_servicio = true>
</cfif>


	<!----id de la lista principal que se envia por el form para no perder el valor--->

	<table width="100%" border="0"  cellpadding="2" cellspacing="0">
		<tr>
			<td class="subTitulo" align="center">Habilitar</td>
			<td class="subTitulo" align="left">Nombre</td>
			<td class="subTitulo" align="left">Descripci&oacute;n</td>
			<td class="subTitulo" align="right">Cantidad permitida</td>
			<td class="subTitulo" <cfif mostrar_servicio>style="visibility:visible"<cfelse>style="visibility:hidden"</cfif> align="left">Paq. Interfaz</td>
		</tr>
		<cfif rsDatos.recordCount>
			<cfloop query="rsDatos">
				<tr><td align="center"><input name="chk" onclick="evaluaChecks('#rsDatos.TStipo#',this); validaServCable();" type="checkbox" value="#rsDatos.TScodigo#" <cfif rsDatos.ch EQ 1> checked</cfif> tabindex="1"/></td>
					<td align="left">#rsDatos.TSnombre#</td>
					<td align="left">#rsDatos.TSobservacion#</td>
					<td align="right">
					<cfif "C_#TScodigo#" eq "C_CABM">
						<cf_campoNumerico name="C_#TScodigo#" decimales="-1" size="10" maxlength="1" value="#rsDatos.cc#" readonly="true" tabindex="1">						
					<cfelse>
						<cf_campoNumerico name="C_#TScodigo#" decimales="-1" size="10" maxlength="8" value="#rsDatos.cc#" tabindex="1">						
					</cfif>
							
					</td>
					
					<td align="left" <cfif mostrar_servicio>style="visibility:visible"<cfelse>style="visibility:hidden"</cfif>>
						<cf_paquete 
							id = "#rsDatos.ci#"
							sufijo = "_#TScodigo#"
							agente = ""
							form = "form1"
							filtroPaqInterfaz = "1"
							sizeCod = "5"
							permInterfaz="1"
							sizeDes = "25"
							showCodigo="false"
							
						>
					</td>
					</tr>
				<cfif rsDatos.ch EQ 1>
					<cfset checks = checks+1>
				</cfif>
			</cfloop>
		</cfif>
	</table>

<script type="text/javascript">
			
	function checkServicios(){
		var i=0;
		var j=0;
		var escero = false;
		var msg = "Los siguientes servicios están habilitados con un valor en cantidad igual a cero:\n";
		<cfif rsDatos.recordCount>
			<cfloop query="rsDatos">
				if(document.getElementsByName("chk")[i].checked){
					msg += "\n\t- #rsDatos.TSnombre#";
					j+=1;
					if (document.form1.C_#TScodigo#.value == "0")
						escero = true;
				
				}
				i+=1;
			</cfloop>
		</cfif>
		
		if(j==0){
			msg="Debe seleccionar al menos un tipo de servicio.";
			alert(msg);
			return false;
		}
		else if (escero){
			msg+="\n\nFavor de especificar un valor mayor.";
			alert(msg);
			return false;							
			}
			return true;	
	}
	
	function validaServCable()
	{
		if (document.getElementsByName("chk")[2].checked)
		{
			document.form1.C_CABM.value = "1";
		}
		else
		{
			document.form1.C_CABM.value = "0";
		}
	}
	
</script></cfoutput>