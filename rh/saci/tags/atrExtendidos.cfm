<!--- NOTA IMPORTANTE: Este tag esta muy relacionado con el componente atrExtendidosPersona.cfc, si se desea modificar debe vericarse 
tambien que funcione con dicho componente, pues este se encarga de realizar el proceso de agregado y modificado de los valores de los campos 
de los atributos extendidos que se pintan en este tag...  el atributo sufijo debe ser el mismo que el argumento sufijo del componente atrExtendidosPersona--->

<cfparam 	name="Attributes.tipo" 				type="string"	default="1">						<!--- Tipo (persona=1, agente=2, cuenta=3)--->
<cfparam 	name="Attributes.id" 				type="string"	default="-1">						<!--- id de la Persona (Pquien)--->
<cfparam 	name="Attributes.identificacion" 	type="string"	default="">							<!--- identificacion de la Persona (Pid)--->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">					<!--- form--->
<cfparam 	name="Attributes.columnas" 			type="string"	default="2">						<!--- Numero de columnas en que desea que se desplieglen los campos--->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">							<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">		<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">			<!--- cache de conexion --->
<cfparam 	name="Attributes.incluyeTabla" 		type="boolean"	default="true">						<!--- si se le agrega tabla o no --->


<cfif Attributes.tipo EQ "1" or Attributes.tipo EQ "2">												<!--- Querys: persona --->
			
	<cfquery datasource="#Attributes.Conexion#" name="rsAtrFisico">									<!--- Consulta de Atributos Extendidos Juridicos---->	
		select	a.Aid,a.Aetiq,a.AtipoDato
				<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>,b.PAvalor as valor</cfif>
		from	ISBatributo a
				<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
				left outer join ISBpersonaAtributo b
					on a.Aid = b.Aid 
					and b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
				</cfif>
		where 	a.Habilitado=1
				and a.AapFisica=1
		order by a.Aorden
	</cfquery>
			
	<cfquery datasource="#Attributes.Conexion#" name="rsAtrJuridico">								<!--- Consulta de Atributos Extendidos Juridicos------->
		select a.Aid,a.Aetiq,a.AtipoDato
				<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>,b.PAvalor as valor</cfif> 
		from ISBatributo a
				<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
				left outer join ISBpersonaAtributo b
					on a.Aid = b.Aid 
					and b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
				</cfif>
		where a.Habilitado=1
			and a.AapJuridica=1
		order by a.Aorden
	</cfquery>
	
<cfelseif Attributes.tipo EQ "3">
	
	<cfquery datasource="#Attributes.Conexion#" name="rsCampos">
		select a.Aid,a.Aetiq,a.AtipoDato 
			<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>,b.AAvalor as valor</cfif> 
		from ISBatributo a
			<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
			left outer join ISBagenteAtributo b
				on a.Aid = b.Aid 
				and b.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
			</cfif>
		where a.Habilitado=1
			and a.AapAgente=1
		order by a.Aorden
	</cfquery>

<cfelseif Attributes.tipo EQ "4">

	<cfquery datasource="#Attributes.Conexion#" name="rsCampos">
		select a.Aid,a.Aetiq,a.AtipoDato 
			<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>,b.VALOR as valor</cfif> 
		from ISBatributo a
			<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
			left outer join ISBcuentaAtributo b
				on a.Aid = b.Aid 
				and b.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
			</cfif>
		where a.Habilitado=1
			and a.AapCuenta=1
		order by a.Aorden
	</cfquery>

<cfelse>
	<cfthrow message="Error: El componente de Atributos Extendidos necesita un tipo válido.<br> Tipos válidos: 1=Persona fisica, 2=Persona Juridica, 3=Agente, 4=Cuenta">
</cfif>

<cfoutput>

<cfif Attributes.incluyeTabla><table cellpadding="0" cellspacing="0" border="0"  width="100%"></cfif>
	
	<!--- Pinta Campos: persona --->
	<cfif Attributes.tipo EQ "1" or Attributes.tipo EQ "2">
		
		<tr id="BloqueJ#Attributes.sufijo#"><td> 
			
			<cfif isdefined("rsAtrJuridico") and rsAtrJuridico.RecordCount GT 0>
				<input name="cantJuridico#Attributes.sufijo#" type="hidden" value="#rsAtrJuridico.RecordCount#" />
				<table cellpadding="2" cellspacing="0" border="0"  width="100%">
					<tr>
						<cfset index=1>
						<cfloop query="rsAtrJuridico">
				
							<td align="right"	valign="middle"><label>#rsAtrJuridico.Aetiq#</label></td>
							<td align="left" 	valign="middle">
									<cfset nomCampoJ= 'J_'& rsAtrJuridico.Aid>
									
									<!--- Pintado del campo Atr.Exten.Juridico. el nombre se compone por: 'J_'+ Aid. Ejemplo: J1  --->
									<cfif rsAtrJuridico.ATipoDato eq "F">
										<cfset fecha = "">
										<cfif isdefined('rsAtrJuridico.valor')>
											<cfset fecha = rsAtrJuridico.valor>
										</cfif>
										<cf_sifcalendario name="#nomCampoJ##Attributes.sufijo#" value="#fecha#" tabindex="1">
										
									<cfelseif  rsAtrJuridico.ATipoDato eq "N">
										<cfset valNum = "">
										<cfif isdefined('rsAtrJuridico.valor')>
											<cfset valNum = HtmlEditFormat(rsAtrJuridico.valor)>
										</cfif>
										<cf_campoNumerico name="#nomCampoJ##Attributes.sufijo#" decimales="-1" size="22" maxlength="18" value="#valNum#" tabindex="1">
									
									<cfelseif  rsAtrJuridico.ATipoDato eq "T">
										<input width="300" name="#nomCampoJ##Attributes.sufijo#" id="#nomCampoJ##Attributes.sufijo#" type="text" value="<cfif isdefined('rsAtrJuridico.valor')>#rsAtrJuridico.valor#</cfif>"maxlength="100" onfocus="this.select()" tabindex="1" />
									
									<cfelseif  rsAtrJuridico.ATipoDato eq "V">
										<cfquery datasource="#Attributes.Conexion#" name="rsValores">
											select LVid,LVnombre
											from ISBatributoValor
											where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAtrJuridico.Aid#">
												and Habilitado=1
											order by LVnombre
										</cfquery>
										<select name="#nomCampoJ##Attributes.sufijo#" id="#nomCampoJ##Attributes.sufijo#" tabindex="1">
											<option value=""></option>
											<cfloop query="rsValores">
												<option value="#rsValores.LVid#"<cfif isdefined('rsAtrJuridico.valor') and rsAtrJuridico.valor EQ rsValores.LVid>selected</cfif>>#rsValores.LVnombre#</option>
											</cfloop>
										</select>
									</cfif>
							</td>
							<cfif index mod Attributes.columnas eq 0></tr><tr></cfif>
							<cfset index=index+1>
							
						</cfloop>
					</tr>
				</table>
			</cfif>
		
		</td></tr>
		
		<tr id="BloqueF#Attributes.sufijo#"><td>																		<!--- Bloque que pinta los Atributos Extendidos Fisicos---->					
			
			 <cfif isdefined("rsAtrFisico") and rsAtrFisico.RecordCount GT 0>
				<input name="cantFisico#Attributes.sufijo#" type="hidden" value="#rsAtrFisico.RecordCount#"/>
				<table cellpadding="2" cellspacing="0" border="0"  width="100%">
					<tr>
						<cfset index=1>
						<cfloop query="rsAtrFisico">
						
							<td valign="middle"	align="right"><label>#rsAtrFisico.Aetiq#</label></td>
							<td valign="middle"	align="left">
							
								<!---nombre del campo input: compuesto por un nombre consecutivo y el id del atributo extendido--->
								<cfset nomCampof='F_'& rsAtrFisico.Aid>
								
								<!--- Pintado del campo Atr.Exten.Fisico. el nombre se compone por: 'F'+ indice consecutivo +'_'+ Aid. Ejemplo: F1_1     style="width: 100%"--->
								<cfif rsAtrFisico.ATipoDato eq "F">
									<cfset fecha = "">
									<cfif isdefined('rsAtrFisico.valor')>
										<cfset fecha = rsAtrFisico.valor>
									</cfif>
									<cf_sifcalendario name="#nomCampof##Attributes.sufijo#"  value="#fecha#" tabindex="1">
									
								<cfelseif  rsAtrFisico.ATipoDato eq "N">
									<cfset valNum = "">
									<cfif isdefined('rsAtrFisico.valor')>
										<cfset valNum = HtmlEditFormat(rsAtrFisico.valor)>
									</cfif>
									<cf_campoNumerico name="#nomCampof##Attributes.sufijo#" decimales="-1" size="22" maxlength="18" value="#valNum#" tabindex="1">
								
								<cfelseif  rsAtrFisico.ATipoDato eq "T">
									<input width="300" name="#nomCampof##Attributes.sufijo#" id="#nomCampof##Attributes.sufijo#" type="text" value="<cfif isdefined('rsAtrFisico.valor')>#rsAtrFisico.valor#</cfif>"maxlength="100" size="30"onfocus="this.select()" tabindex="1" />
								
								<cfelseif  rsAtrFisico.ATipoDato eq "V">
						
									<cfquery datasource="#Attributes.Conexion#" name="rsValores">
										select LVid,LVnombre
										from ISBatributoValor
										where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAtrFisico.Aid#">
											  and Habilitado=1
										order by LVnombre
									</cfquery>
									
									<select name="#nomCampof##Attributes.sufijo#" id="#nomCampof##Attributes.sufijo#" tabindex="1">
										<option value=""></option>
										<cfloop query="rsValores">
											<option value="#rsValores.LVid#"<cfif isdefined('rsAtrFisico.valor') and rsAtrFisico.valor EQ rsValores.LVid>Selected</cfif>>#rsValores.LVnombre#</option>
										</cfloop>
									</select>
													
								</cfif>
							</td>
							<cfif index mod Attributes.columnas eq 0></tr><tr></cfif>
							
							<cfset index=index+1>
						
						</cfloop>
					</tr>
				</table>
			</cfif>
			
		</td></tr>
	
	<cfelseif Attributes.tipo EQ "3" or Attributes.tipo EQ "4">
		
		<cfif isdefined("rsCampos") and rsCampos.RecordCount GT 0>
			
			<cfset letra = ''>
			<cfif Attributes.tipo EQ "3">																		<!--- Pinta Campos: agente--->
				<cfset letra='A_'>
			<cfelseif Attributes.tipo EQ "4">																	<!--- Pinta Campos: cuenta --->
				<cfset letra='C_'>
			</cfif>
			
			<tr><td>

			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<cfset index=1>
					<cfloop query="rsCampos">
			
						<td align="right"	valign="middle"><label>#rsCampos.Aetiq#</label></td>
						<td align="left" 	valign="middle">
								<cfset nomCampo = letra & rsCampos.Aid>
								
								<cfif rsCampos.ATipoDato eq "F">
									<cfset fecha = "">
									<cfif isdefined('rsCampos.valor')>
										<cfset fecha = rsCampos.valor>
									</cfif>
									<cf_sifcalendario name="#nomCampo##Attributes.sufijo#" value="#fecha#" tabindex="1">
									
								<cfelseif  rsCampos.ATipoDato eq "N">
									<cfset valNum = "">
									<cfif isdefined('rsCampos.valor')>
										<cfset valNum = HtmlEditFormat(rsCampos.valor)>
									</cfif>
									<cf_campoNumerico name="#nomCampo##Attributes.sufijo#" decimales="-1" size="22" maxlength="18" value="#valNum#" tabindex="1">
								
								<cfelseif  rsCampos.ATipoDato eq "T">
									<input width="300" name="#nomCampo##Attributes.sufijo#" id="#nomCampo##Attributes.sufijo#" type="text" value="<cfif isdefined('rsCampos.valor')>#rsCampos.valor#</cfif>" maxlength="100" onfocus="this.select()" tabindex="1" />
								
								<cfelseif  rsCampos.ATipoDato eq "V">
									<cfquery datasource="#Attributes.Conexion#" name="rsValores">
										select LVid,LVnombre
										from ISBatributoValor
										where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.Aid#">
											  and Habilitado=1	
										order by LVnombre
									</cfquery>
									<select name="#nomCampo##Attributes.sufijo#" id="#nomCampo##Attributes.sufijo#" tabindex="1">
										<option value=""></option>
										<cfloop query="rsValores">
											<option value="#rsValores.LVid#"<cfif isdefined('rsCampos.valor') and rsCampos.valor EQ rsValores.LVid>Selected</cfif>>#rsValores.LVnombre#</option>
										</cfloop>
									</select>
								</cfif>
						</td>
						<cfif index mod Attributes.columnas eq 0></tr><tr></cfif>
						<cfset index=index+1>
						
					</cfloop>
				</tr>
			</table>
			
			</td></tr>
		</cfif>
				
	</cfif>
	
<cfif Attributes.incluyeTabla></table></cfif>

<!------------------------------ Sentencia Iframe-------------------------------->
<iframe id="atrExtendidos#Attributes.sufijo#" name="atrExtendidos#Attributes.sufijo#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>

<script language="javascript">

	<!------------------------- Función que actualiza los valores de los campos de los Atr. Extendidos ------------------------>
	function ActualizaValoresExtendidos#Attributes.sufijo#(tipo,id) {
		if (tipo != '') {
			var fr = document.getElementById("atrExtendidos#Attributes.sufijo#");
			fr.src = "/cfmx/saci/utiles/atrExtendidosUtiles.cfm?tipo="+tipo+"&id="+id+"&form_name=#Attributes.form#&sufijo=#Attributes.sufijo#&conexion=#Attributes.Conexion#";
		}
		return true;
	}

	<cfif Attributes.tipo EQ "1" or Attributes.tipo EQ "2">																					<!--- Querys: persona --->
	<!------------------------- Función que aparece y desaparece los bloques de campos segun el tipo ------------------------>
	function MostrarCampos#Attributes.sufijo#(tipo) {
		if (tipo == "2") {
				document.getElementById("BloqueJ#Attributes.sufijo#").style.display='';	
				document.getElementById("BloqueF#Attributes.sufijo#").style.display='none';
		} else if (tipo == "1") {
				document.getElementById("BloqueJ#Attributes.sufijo#").style.display='none';
				document.getElementById("BloqueF#Attributes.sufijo#").style.display='';	
		} else{
				document.getElementById("BloqueJ#Attributes.sufijo#").style.display='none';
				document.getElementById("BloqueF#Attributes.sufijo#").style.display='none';
		}
	}
	</cfif>
	
</script>

</cfoutput>
