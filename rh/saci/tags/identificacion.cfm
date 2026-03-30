<cfparam 	name="Attributes.alignEtiquetas" 		type="string"	default="left">								<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.incluyeTabla" 			type="boolean"	default="true">								<!--- incluye tabla --->
<cfparam 	name="Attributes.porFila" 				type="boolean"	default="false">							<!--- se utiliza para indicar si se pintan los niveles por columna o fila --->
<cfparam 	name="Attributes.colspan" 				type="integer"	default="1">								<!--- colspan para campo de identificacion --->
<cfparam	name="Attributes.onchangePersoneria"	type="string"	default="">									<!--- Función a invocar en el cambio de personeria --->
<cfparam	name="Attributes.funcion"				type="string"	default="">									<!--- Función a invocar después del llamado al conlis --->
<cfparam	name="Attributes.funcionValorEnBlanco"	type="string"	default="">									<!--- Función a invocar cuando el valor esta en blanco --->
<cfparam	name="Attributes.editable"				type="boolean"	default="true">								<!--- Se usa para indicar si el tag se usa como campo editable, para que el conlis no elimine el valor digitado cuando se digita un valor que no existe --->
<cfparam	name="Attributes.ocultarPersoneria"		type="boolean"	default="false">							<!--- Se usa para indicar si se muestra la personeria --->
<cfparam	name="Attributes.filtrarPersoneria"		type="string"	default="">									<!--- Se usa para filtrar los tipos de personeria que se requieren, se envían los códigos que se desean mostrar --->
<cfparam	name="Attributes.readonly"				type="boolean"	default="false">							<!--- Indica si el campo de identificacion es readonly --->
<cfparam	name="Attributes.soloAgentes"			type="boolean"	default="false">							<!--- Se usa para indicar si se muestra solo personas que son agentes --->
<cfparam	name="Attributes.soloVendedores"		type="boolean"	default="false">							<!--- Se usa para indicar si se muestra solo personas que son Vendedores --->
<cfparam 	name="Attributes.id"					type="string"	default="">									<!--- Id de la Persona--->
<cfparam 	name="Attributes.form" 					type="string"	default="form1">							<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">									<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.pais" 					type="string"	default="#session.saci.pais#">				<!--- código de país --->
<cfparam 	name="Attributes.Ecodigo" 				type="string"	default="#Session.Ecodigo#">				<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">					<!--- cache de conexion --->
<cfparam	name="Attributes.pintaEtiq"				type="boolean"	default="true">								<!--- Se usa para indicar si se muestran o no las etiquetas --->
<cfparam 	name="Attributes.keyProspecto"			type="boolean"	default="false">							<!--- El Attributes.id es de la tabla ISBprospectos --->
<cfparam 	name="Attributes.TipodeAgente"			type="string"	default="Interno">							<!--- Indica si es un Vendedor de RACSA o un Agente Autorizado --->

<!---atributos nuevos para localizacion--->
<cfparam 	name="Attributes.TypeLocation"			type="string"	default="P">								<!--- Tipo de Entidad que usa el TAG, por ej: Agente, cuenta, cliente, representante.... --->
<cfparam 	name="Attributes.RefIdLocation"			type="string"	default="-1">									<!--- Id de Referencia asociado a la localizacion --->
<!---fin / atributos nuevos para localizacion--->
<cfparam 	name="Attributes.id_duenno"				type="string"	default="-1">									<!--- Se usa para realizar el filtro de los representantes --->


<cfset filtro_personeria = "">

<cfif not len(trim(Attributes.funcion))>
	<cfset Attributes.funcion = 'formatMascara' & Attributes.sufijo>
</cfif>

<cfset filtroPersonerias = Attributes.filtrarPersoneria>
<cfif Len(Trim(filtroPersonerias))>
	<cfset filtroPersonerias = "'" & Replace(filtroPersonerias, ",", "','", 'all') & "'">
</cfif>

<cfif Attributes.readonly and Len(Trim(Attributes.id)) EQ 0>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo id">
</cfif>


<cfquery name="rsTipoIdentificacion" datasource="#Attributes.Conexion#">
	select a.Ppersoneria
		, a.Pfisica
		, a.Pdescripcion
		, a.Pregex
		, a.PetiquetaCaptura
		, case a.Ppersoneria
			when 'F' then 1
			when 'J' then 2	
			when 'R' then 3
			when 'E' then 4
		end Orden		
	from ISBtipoPersona a
	Where Ppersoneria != 'R'
	<cfif Len(Trim(filtroPersonerias))>
	 and a.Ppersoneria in (#preserveSingleQuotes(filtroPersonerias)#)	
	</cfif>
	order by Orden
</cfquery>


<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
	<cfif Attributes.TypeLocation eq "P">
		<cfquery datasource="#Attributes.Conexion#" name="rsPersona">
			select 
				   <cfif Attributes.keyProspecto>
						'' as Pquien,			   
				   <cfelse>
						a.Pquien, 
				   </cfif>				
				   a.Ppersoneria, 
				   a.Pid, 
				   a.Pnombre, 
				   a.Papellido, 
				   a.Papellido2, 
				   a.PrazonSocial, 
				   a.Ppais, 
				   a.Pobservacion, 
				   a.Pprospectacion, 
				   <cfif Attributes.keyProspecto>
						'' as AEactividad,			   
				   <cfelse>
						a.AEactividad, 
				   </cfif>
				   a.CPid, 
				   rtrim(a.Papdo) as Papdo, 
				   a.LCid, 
				   a.Pdireccion, 
				   a.Pbarrio, 
				   a.Ptelefono1, 
				   a.Ptelefono2, 
				   a.Pfax, 
				   a.Pemail, 
				   a.Pfecha, 
				   case a.Ppersoneria 
						when 'J' then  a.PrazonSocial
						else  rtrim(rtrim(a.Pnombre) || ' ' || rtrim(a.Papellido) || ' ' || a.Papellido2) 
				   end as nom_razon,
				   a.ts_rversion,
				   coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) as AGid,
				   coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) as Vid
			from 
				<cfif Attributes.keyProspecto>
					ISBprospectos a
				<cfelse>
					ISBpersona a
				</cfif>	
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
			<cfif not Attributes.keyProspecto>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
			</cfif>					
			<cfif Len(Trim(filtroPersonerias))>
				and a.Ppersoneria in (#preserveSingleQuotes(filtroPersonerias)#)
			</cfif>
		</cfquery>
	<cfelse>
		<!--- Verifica si existe Localizacion--->
		
		<cfquery datasource="#Attributes.Conexion#" name="rsExistsLocation">
			select count(1) as r
				from ISBlocalizacion 
			where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
		</cfquery>
		
		<cfset ExistsLocation = false>
		<cfif rsExistsLocation.r gt 0>
			<cfset ExistsLocation = true>
		</cfif>
		<cfif ExistsLocation>
			<!---<cfif Attributes.TypeLocation eq "A" or Attributes.TypeLocation eq "C" or Attributes.TypeLocation eq "V">--->
				<cfquery datasource="#Attributes.Conexion#" name="rsPersona">
					select 
						   a.Pquien, 
						   a.Ppersoneria, 
						   a.Pid, 
						   a.Pnombre, 
						   a.Papellido, 
						   a.Papellido2, 
						   a.PrazonSocial, 
						   a.Ppais, 
						   a.Pprospectacion, 
						   a.AEactividad, 
						   
						   c.CPid, 
						   rtrim(c.Papdo) as Papdo, 
						   c.LCid, 
						   c.Pdireccion, 
						   c.Pbarrio, 
						   rtrim(c.Ptelefono1) as Ptelefono1, 
						   rtrim(c.Ptelefono2) as Ptelefono2, 
						   rtrim(c.Pfax) as Pfax, 
						   c.Pemail, 
						   c.Pobservacion, 
						   c.Pfecha,
						   
						   case a.Ppersoneria 
								when 'J' then  a.PrazonSocial
								else  rtrim(rtrim(a.Pnombre) || ' ' || rtrim(a.Papellido) || ' ' || a.Papellido2) 
						   end as nom_razon,
						   a.ts_rversion,
						   coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) as AGid,
						   coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) as Vid
					from 
						ISBpersona a inner join
									<cfif Attributes.TypeLocation eq "A">
										ISBagente b on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "C">
										ISBcuenta  b on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "V">
										ISBvendedor b on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "R">
										ISBpersonaRepresentante b on a.Pquien = b.Pcontacto
									</cfif>
								
							 inner join ISBlocalizacion c 
								on c.RefId = 
									<cfif Attributes.TypeLocation eq "A">
										b.AGid
									<cfelseif Attributes.TypeLocation eq "C">
										b.CTid
									<cfelseif Attributes.TypeLocation eq "V">
										b.Vid
									<cfelseif Attributes.TypeLocation eq "R">
										b.Rid 
									</cfif>
					where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
						and c.RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
					<cfif Len(Trim(filtroPersonerias))>
						and a.Ppersoneria in (#preserveSingleQuotes(filtroPersonerias)#)
					</cfif>
				</cfquery>
		<cfelse>
			<cfquery datasource="#Attributes.Conexion#" name="rsPersona">
				select 
					   a.Pquien, 
					   a.Ppersoneria, 
					   a.Pid, 
					   a.Pnombre, 
					   a.Papellido, 
					   a.Papellido2, 
					   a.PrazonSocial, 
					   a.Ppais, 
					   a.Pprospectacion, 
					   a.AEactividad, 
					   null as CPid, 
					   null as Papdo, 
					   null as LCid, 
					   null as Pdireccion, 
					   null as Pbarrio, 
					   null as Ptelefono1, 
					   null as Ptelefono2, 
					   null as Pfax, 
					   null as Pemail, 
					   null as Pobservacion, 
					   null as Pfecha, 
					   case a.Ppersoneria 
							when 'J' then  a.PrazonSocial
							else  rtrim(rtrim(a.Pnombre) || ' ' || rtrim(a.Papellido) || ' ' || a.Papellido2) 
					   end as nom_razon,
					   a.ts_rversion,
					   coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) as AGid,
					   coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) as Vid
				from 
					ISBpersona a
					
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
					
				<cfif Len(Trim(filtroPersonerias))>
					and a.Ppersoneria in (#preserveSingleQuotes(filtroPersonerias)#)
				</cfif>
			</cfquery>
		
		</cfif>
	</cfif>
</cfif>

<cfoutput>

	<cfif Attributes.incluyeTabla>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	</cfif>
		<tr>
			<cfif not Attributes.ocultarPersoneria>
				<cfset filtro_personeria = "and a.Ppersoneria = $Ppersoneria#Attributes.sufijo#,char$">
				
				<cfif Attributes.pintaEtiq>
					<td align="#Attributes.alignEtiquetas#"><label>Personer&iacute;a</label></td>
				</cfif>	
				<td>
					<cfif Attributes.readonly>
						<cfif rsPersona.Ppersoneria EQ 'F'>		<cfset tipo_personeria = "Física">
						<cfelseif rsPersona.Ppersoneria EQ 'J'>	<cfset tipo_personeria = "Jurídica">
						<cfelseif rsPersona.Ppersoneria EQ 'R'>	<cfset tipo_personeria = "Extrangero Residente">
						<cfelseif rsPersona.Ppersoneria EQ 'E'>	<cfset tipo_personeria = "Extrangero"></cfif>
						<input type="text" tabindex="1" value="#tipo_personeria#" readonly class="cajasinbordeb" />
						<input type="hidden" name="Ppersoneria#Attributes.sufijo#"	value="#rsPersona.Ppersoneria#"/>
					<cfelse>	
						<select name="Ppersoneria#Attributes.sufijo#" onChange="javascript: validar_identificacion#Attributes.sufijo#(); resetMascara();<cfif Len(Trim(Attributes.onchangePersoneria))>#Trim(Attributes.onchangePersoneria)#();</cfif>" tabindex="1">
						<cfloop query="rsTipoIdentificacion">
							<option value="#rsTipoIdentificacion.Ppersoneria#"<cfif isdefined("rsPersona") and rsPersona.Ppersoneria EQ rsTipoIdentificacion.Ppersoneria> selected</cfif> >#rsTipoIdentificacion.Pdescripcion#</option>
						</cfloop>
						</select>
					</cfif>
				</td>
				<cfif Attributes.porFila></tr><tr></cfif>
			</cfif>
			<cfif Attributes.pintaEtiq>
				<td align="#Attributes.alignEtiquetas#"><label><cfif Attributes.soloAgentes>Agente<cfelse>Identificaci&oacute;n</cfif></label></td>
			</cfif>				
			<td <cfif Attributes.colspan GT 1>colspan="#Attributes.colspan#"</cfif>>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>
						<cfif not Attributes.readonly>
							<cfif not Attributes.ocultarPersoneria>
								<cfset fvalidacion = "validar_identificacion#Attributes.sufijo#">
								<cfset anterior = "anterior#Attributes.sufijo#">
								<cfset getTecla="getTecla#Attributes.sufijo#">
							<cfelse>
								<cfset fvalidacion = "">
								<cfset anterior = "">
								<cfset getTecla="">
							</cfif>
							
							<cfset filtroAdic = "">
							<cfif Len(Trim(filtroPersonerias))>
								<cfset filtroAdic = filtroAdic & " and a.Ppersoneria in (#preserveSingleQuotes(filtroPersonerias)#) ">
							</cfif>
							<cfif Attributes.soloAgentes>
								<cfset filtroAdic = filtroAdic & " and coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) <> 0">
							</cfif>
							<cfif Attributes.soloVendedores>
								<cfset filtroAdic = filtroAdic & " and coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) <> 0">
							</cfif>							
							<cfset array = ArrayNew(1)>
							<cfif isdefined("rsPersona")and rsPersona.RecordCount NEQ 0>
							<!--- pinta el conlis con valores del registro seleccionado --->

								<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
								<cfset temp = ArraySet(array, 1,25, "")>
								<cfset array[1] = rsPersona.Pquien>
								<cfset array[2] = rsPersona.Pid>    
								<cfset array[3] = rsPersona.Pid>    
								<cfset array[4] = rsPersona.Pnombre>
								<cfset array[5] = rsPersona.Papellido>
								<cfset array[6] = rsPersona.Papellido2>
								<cfset array[7] = rsPersona.Ppersoneria>
								<cfset array[8] = rsPersona.PrazonSocial>
								<cfset array[9] = rsPersona.nom_razon>
								<cfset array[10] = rsPersona.Ppais>
								<cfset array[11] = rsPersona.Pobservacion>
								<cfset array[12] = rsPersona.CPid>
								<cfset array[13] = "">
								<cfset array[14] = rsPersona.Papdo>
								<cfset array[15] = rsPersona.LCid>
								<cfset array[16] = rsPersona.Pdireccion>
								<cfset array[17] = rsPersona.Pbarrio>
								<cfset array[18] = rsPersona.Ptelefono1>
								<cfset array[19] = rsPersona.Ptelefono2>
								<cfset array[20] = rsPersona.Pfax>
								<cfset array[21] = rsPersona.Pemail>
								<cfset array[22] = rsPersona.AEactividad>
								<cfset array[23] = rsPersona.AGid>
								<cfset array[24] = rsPersona.Vid>
								<cfset array[25] = rsPersona.ts_rversion>
							</cfif>
								
								<cfif Attributes.TypeLocation eq "P">
								
							  		<cf_conlis 
										title="Persona"
										campos = "Pquien#Attributes.sufijo#,Pid#Attributes.sufijo#,PidSinMask#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#,
													Ppersoneriap#Attributes.sufijo#, PrazonSocialp#Attributes.sufijo#, nom_razonp#Attributes.sufijo#,
													Ppaisp#Attributes.sufijo#,Pobservacionp#Attributes.sufijo#,
													CPidp#Attributes.sufijo#,CPnombrep#Attributes.sufijo#, Papdop#Attributes.sufijo#, LCidp#Attributes.sufijo#, 
													Pdireccionp#Attributes.sufijo#,Pbarriop#Attributes.sufijo#,
													Ptelefono1p#Attributes.sufijo#,Ptelefono2p#Attributes.sufijo#,
													Pfaxp#Attributes.sufijo#,Pemailp#Attributes.sufijo#,AEactividadp#Attributes.sufijo#,AGidp#Attributes.sufijo#,Vidp#Attributes.sufijo#,ts_rversionp#Attributes.sufijo#"
										desplegables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N" 
										modificables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N"
										size = "0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
										tabla="ISBpersona a 
											   left outer join OficinaPostal b
													on b.CPid = a.CPid
													and b.Ppais = '#Attributes.pais#'"
										columnas="a.Pquien as Pquien#Attributes.sufijo#,a.Pid as Pid#Attributes.sufijo#, a.Pid as PidSinMask#Attributes.sufijo#,
													a.Pnombre as Pnombrep#Attributes.sufijo#,a.Papellido as Papellidop#Attributes.sufijo#,a.Papellido2 as Papellido2p#Attributes.sufijo#,
													a.Ppersoneria as Ppersoneriap#Attributes.sufijo#, a.PrazonSocial as PrazonSocialp#Attributes.sufijo#,
													case a.Ppersoneria 
														when 'J' then  a.PrazonSocial
														else  rtrim(rtrim(a.Pnombre) || ' ' || rtrim(a.Papellido) || ' ' || a.Papellido2) 
													end as nom_razonp#Attributes.sufijo#,
													a.Ppais as Ppaisp#Attributes.sufijo#,a.Pobservacion as Pobservacionp#Attributes.sufijo#,
													a.CPid as CPidp#Attributes.sufijo#, b.CPnombre as CPnombrep#Attributes.sufijo#, rtrim(a.Papdo) as Papdop#Attributes.sufijo#, a.LCid as LCidp#Attributes.sufijo#, 
													a.Pdireccion as Pdireccionp#Attributes.sufijo#,a.Pbarrio as Pbarriop#Attributes.sufijo#,
													rtrim(a.Ptelefono1) as Ptelefono1p#Attributes.sufijo#,rtrim(a.Ptelefono2) as Ptelefono2p#Attributes.sufijo#,
													rtrim(a.Pfax) as Pfaxp#Attributes.sufijo#, a.Pemail as Pemailp#Attributes.sufijo#, a.AEactividad as AEactividadp#Attributes.sufijo#, a.ts_rversion as ts_rversionp#Attributes.sufijo#,
													coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) as AGidp#Attributes.sufijo#,
													coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) as Vidp#Attributes.sufijo#" 
										filtro="a.Ecodigo = #Attributes.Ecodigo# #filtro_personeria#
												#preserveSingleQuotes(filtroAdic)#
												order by a.Pid, a.Pnombre, a.Papellido, a.Papellido2"
										filtrar_por="a.Pid, a.Pnombre, a.Papellido, a.Papellido2"
										desplegar="Pid#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#"
										etiquetas="Identificaci&oacute;n,Nombre,1er Apellido,2do Apellido"
										formatos="S,S,S,S"
										align="left,left,left,left"
										asignar="Pquien#Attributes.sufijo#,Pid#Attributes.sufijo#,PidSinMask#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#,
													Ppersoneriap#Attributes.sufijo#, PrazonSocialp#Attributes.sufijo#, nom_razonp#Attributes.sufijo#,
													Ppaisp#Attributes.sufijo#,Pobservacionp#Attributes.sufijo#,
													CPidp#Attributes.sufijo#,CPnombrep#Attributes.sufijo#,Papdop#Attributes.sufijo#,LCidp#Attributes.sufijo#, 
													Pdireccionp#Attributes.sufijo#,Pbarriop#Attributes.sufijo#,
													Ptelefono1p#Attributes.sufijo#,Ptelefono2p#Attributes.sufijo#,
													Pfaxp#Attributes.sufijo#,Pemailp#Attributes.sufijo#,AEactividadp#Attributes.sufijo#,AGidp#Attributes.sufijo#,Vidp#Attributes.sufijo#,ts_rversionp#Attributes.sufijo#"
										asignarformatos="I,S,S,S,S,S,S,S,S,S,I,S,S,I,S,S,S,S,S,S,S,S,S,S,T"
										Form="#Attributes.form#"
										Conexion="#Attributes.Conexion#"
										onkeyup="#fvalidacion#"
										onchange="#fvalidacion#"
										onfocus="#fvalidacion#"
										onKeydown="#anterior#"
										onkeypress="#getTecla#"
										funcion="#Attributes.funcion#"
										funcionValorEnBlanco="#Attributes.funcionValorEnBlanco#"
										valuesArray="#array#"
										permiteNuevo="#Attributes.editable#"
										closeOnExit="true"
										onblur="eliminaMascara#Attributes.sufijo#"
										tabindex="1">
										<!---onblur="eliminaMascara#Attributes.sufijo#"--->
										
								<cfelse>
								
									<cfset tbjoins = "">
									<cfset tbRefIdfilter = "">
									
										<!---<cfif Attributes.TypeLocation eq "A" or Attributes.TypeLocation eq "C" or Attributes.TypeLocation eq "V">--->
											<cfif Attributes.TypeLocation eq "A">
												<cfset tbjoins = "#tbjoins# left outer join ISBagente b on a.Pquien = b.Pquien">
												<cfif Attributes.TipodeAgente eq 'Interno'>										
													<cfset  tbjoins = "#tbjoins#" & " and b.AAinterno = 1">
												<cfelse>
													<cfset  tbjoins = "#tbjoins#" & " and b.AAinterno = 0">
												</cfif>
											<cfelseif Attributes.TypeLocation eq "C">
												<cfset tbjoins = "#tbjoins# left outer join ISBcuenta b on a.Pquien = b.Pquien">
											<cfelseif Attributes.TypeLocation eq "V">
												<cfset tbjoins = "#tbjoins# left outer join ISBvendedor b on a.Pquien = b.Pquien">
											<cfelseif Attributes.TypeLocation eq "R">
												<cfset tbjoins = "#tbjoins# left outer join ISBpersonaRepresentante b on a.Pquien = b.Pcontacto">
												<cfset tbjoins = "#tbjoins#" & " and b.Pquien = #Attributes.id_duenno#">
											</cfif>
											
											<cfset tbjoins = "#tbjoins# left outer join ISBlocalizacion c on c.RefId = ">
										
										
										<cfif Attributes.TypeLocation eq "A">
											<cfset tbjoins = "#tbjoins# b.AGid">
										<cfelseif Attributes.TypeLocation eq "C">
											<cfset tbjoins = "#tbjoins# b.CTid">
										<cfelseif Attributes.TypeLocation eq "V">
											<cfset tbjoins = "#tbjoins# b.Vid">
										<cfelseif Attributes.TypeLocation eq "R">
											<cfset tbjoins = "#tbjoins# b.Rid ">
										</cfif>
										
										<cfif len(trim(Attributes.RefIdLocation))>
											<cfset tbRefIdfilter = "  and c.RefId = #Attributes.RefIdLocation#">
										</cfif>
										
<!---										<cfif Attributes.TypeLocation eq "R">
											<cfset tbRefIdfilter = "  and not exists(select 1 from ISBpersonaRepresentante x where c.RefId = x.Rid)">
										</cfif>--->										
								
									<cf_conlis 
										title="Persona"
										campos = "Pquien#Attributes.sufijo#,Pid#Attributes.sufijo#,PidSinMask#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#,
													Ppersoneriap#Attributes.sufijo#, PrazonSocialp#Attributes.sufijo#, nom_razonp#Attributes.sufijo#,
													Ppaisp#Attributes.sufijo#,Pobservacionp#Attributes.sufijo#,
													CPidp#Attributes.sufijo#,CPnombrep#Attributes.sufijo#, Papdop#Attributes.sufijo#, LCidp#Attributes.sufijo#, 
													Pdireccionp#Attributes.sufijo#,Pbarriop#Attributes.sufijo#,
													Ptelefono1p#Attributes.sufijo#,Ptelefono2p#Attributes.sufijo#,
													Pfaxp#Attributes.sufijo#,Pemailp#Attributes.sufijo#,AEactividadp#Attributes.sufijo#,AGidp#Attributes.sufijo#,Vidp#Attributes.sufijo#,ts_rversionpp#Attributes.sufijo#,ts_rversionlp#Attributes.sufijo#,
													ts_rversion_agente_i#Attributes.sufijo#,Lidp#Attributes.sufijo#"
										desplegables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N" 
										modificables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N"
										size = "0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
										tabla="ISBpersona a #tbjoins#
											   left outer join OficinaPostal op
													on op.CPid = a.CPid
													and op.Ppais = '#Attributes.pais#'"
										columnas="a.Pquien as Pquien#Attributes.sufijo#,a.Pid as Pid#Attributes.sufijo#, a.Pid as PidSinMask#Attributes.sufijo#,
													a.Pnombre as Pnombrep#Attributes.sufijo#,a.Papellido as Papellidop#Attributes.sufijo#,a.Papellido2 as Papellido2p#Attributes.sufijo#,
													a.Ppersoneria as Ppersoneriap#Attributes.sufijo#, a.PrazonSocial as PrazonSocialp#Attributes.sufijo#,
													case a.Ppersoneria
														when 'J' then  a.PrazonSocial
														else  rtrim(rtrim(a.Pnombre) || ' ' || rtrim(a.Papellido) || ' ' || a.Papellido2) 
													end as nom_razonp#Attributes.sufijo#,
													a.Ppais as Ppaisp#Attributes.sufijo#,c.Pobservacion as Pobservacionp#Attributes.sufijo#,
													c.CPid as CPidp#Attributes.sufijo#, op.CPnombre as CPnombrep#Attributes.sufijo#, rtrim(c.Papdo) as Papdop#Attributes.sufijo#, c.LCid as LCidp#Attributes.sufijo#, 
													c.Pdireccion as Pdireccionp#Attributes.sufijo#,c.Pbarrio as Pbarriop#Attributes.sufijo#,
													rtrim(c.Ptelefono1) as Ptelefono1p#Attributes.sufijo#,rtrim(c.Ptelefono2) as Ptelefono2p#Attributes.sufijo#,
													rtrim(c.Pfax) as Pfaxp#Attributes.sufijo#, c.Pemail as Pemailp#Attributes.sufijo#, a.AEactividad as AEactividadp#Attributes.sufijo#, a.ts_rversion as ts_rversionpp#Attributes.sufijo#,c.ts_rversion as ts_rversionlp#Attributes.sufijo#,
													b.ts_rversion as ts_rversion_agente_i#Attributes.sufijo#,coalesce((select max(AGid) from ISBagente x where x.Pquien = a.Pquien), 0) as AGidp#Attributes.sufijo#,
													coalesce((select max(Vid) from ISBvendedor x where x.Pquien = a.Pquien), 0) as Vidp#Attributes.sufijo#,	
													c.Lid as Lidp#Attributes.sufijo#"
										filtro="a.Ecodigo = #Attributes.Ecodigo# #filtro_personeria# #tbRefIdfilter#
												#preserveSingleQuotes(filtroAdic)#
												order by a.Pid, a.Pnombre, a.Papellido, a.Papellido2"
										filtrar_por="a.Pid, a.Pnombre, a.Papellido, a.Papellido2"
										desplegar="Pid#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#"
										etiquetas="Identificaci&oacute;n,Nombre,1er Apellido,2do Apellido"
										formatos="S,S,S,S"
										align="left,left,left,left"
										asignar="Pquien#Attributes.sufijo#,Pid#Attributes.sufijo#,PidSinMask#Attributes.sufijo#,Pnombrep#Attributes.sufijo#,Papellidop#Attributes.sufijo#,Papellido2p#Attributes.sufijo#,
													Ppersoneriap#Attributes.sufijo#, PrazonSocialp#Attributes.sufijo#, nom_razonp#Attributes.sufijo#,
													Ppaisp#Attributes.sufijo#,Pobservacionp#Attributes.sufijo#,
													CPidp#Attributes.sufijo#,CPnombrep#Attributes.sufijo#,Papdop#Attributes.sufijo#,LCidp#Attributes.sufijo#, 
													Pdireccionp#Attributes.sufijo#,Pbarriop#Attributes.sufijo#,
													Ptelefono1p#Attributes.sufijo#,Ptelefono2p#Attributes.sufijo#,
													Pfaxp#Attributes.sufijo#,Pemailp#Attributes.sufijo#,AEactividadp#Attributes.sufijo#,ts_rversionpp#Attributes.sufijo#,ts_rversionlp#Attributes.sufijo#,
													ts_rversion_agente_i#Attributes.sufijo#,AGidp#Attributes.sufijo#,Vidp#Attributes.sufijo#,
													Lidp#Attributes.sufijo#"
										asignarformatos="I,S,S,S,S,S,S,S,S,S,I,S,S,I,S,S,S,S,S,S,S,S,S,S,S,S,T,I"
										Form="#Attributes.form#"
										Conexion="#Attributes.Conexion#"
										onkeyup="#fvalidacion#"
										onchange="#fvalidacion#"
										onfocus="#fvalidacion#"
										onKeydown="#anterior#"
										onkeypress="#getTecla#"
										funcion="#Attributes.funcion#"
										funcionValorEnBlanco="#Attributes.funcionValorEnBlanco#"
										valuesArray="#array#"
										permiteNuevo="#Attributes.editable#"
										closeOnExit="true"
										onblur="eliminaMascara#Attributes.sufijo#"
										tabindex="1">
										<!---onblur="eliminaMascara#Attributes.sufijo#"--->
								</cfif>
						<cfelse>
							<input type="hidden" name="Pquien#Attributes.sufijo#" id="Pquien#Attributes.sufijo#" value="#rsPersona.Pquien#" />
							<input type="hidden" name="Pid#Attributes.sufijo#" id="Pid#Attributes.sufijo#" value="#rsPersona.Pid#" />
							<input type="hidden" name="nom_razonp#Attributes.sufijo#" id="nom_razonp#Attributes.sufijo#" value="#rsPersona.nom_razon#" />
							<input type="hidden" name="AGidp#Attributes.sufijo#" id="AGidp#Attributes.sufijo#" value="#rsPersona.AGid#" />
							<input type="hidden" name="PidSinMask#Attributes.sufijo#" id="PidPidSinMask#Attributes.sufijo#" value="#rsPersona.Pid#" /><!---Identificacion sin mascara, es la que se va a usar para tomar el valor del Pid e insertarlo en la base de datos--->

							<cfset idConMask=rsPersona.Pid>
							<cfif rsPersona.Ppersoneria EQ 'F'>		<cfset idConMask= Mid(rsPersona.Pid,1,1)&'-'& Mid(rsPersona.Pid,2,4)&'-'& Mid(rsPersona.Pid,6,9)><!---X-XXXX-XXXX persona física--->
							<cfelseif rsPersona.Ppersoneria EQ 'J'>	<cfset idConMask= Mid(rsPersona.Pid,1,1)&'-'& Mid(rsPersona.Pid,2,3)&'-'& Mid(rsPersona.Pid,5,10)><!---X-XXX-XXXXXX persona Juridica--->
							<cfelseif rsPersona.Ppersoneria EQ 'R'>	<cfset idConMask= Mid(rsPersona.Pid,1,3)&'-'& Mid(rsPersona.Pid,4,6)&'-'& Mid(rsPersona.Pid,10,15)><!---XXX-XXXXXX-XXXXXX Extrangero Residente--->
							<cfelseif rsPersona.Ppersoneria EQ 'E'>	<!---<cfset idConMask= '['& Mid(rsPersona.Pid,1,1)&'-'& Mid(rsPersona.Pid,2,2)&']['& Mid(rsPersona.Pid,3,3)&'-'& Mid(rsPersona.Pid,4,4)&']'>---><!---[A-Z][0-9] Extrangero--->
							</cfif>
							#idConMask#
						</cfif>
						
					</td>
					<cfif not Attributes.ocultarPersoneria >
					<td nowrap>
						<img src="/cfmx/saci/images/Borrar01_S.gif" name="img_ident_mal#Attributes.sufijo#" id="img_ident_mal#Attributes.sufijo#" width="20" height="18" border="0" style="display:none">
						<img src="/cfmx/saci/images/check-verde.gif" name="img_ident_ok#Attributes.sufijo#" id="img_ident_ok#Attributes.sufijo#" width="20" height="18" border="0" style="display:none">
						<img src="/cfmx/saci/images/blank.gif" name="img_ident_blank#Attributes.sufijo#" id="img_ident_blank#Attributes.sufijo#" width="20" height="18" border="0">
					</td>
					<td nowrap>
						<input type="text" id="explicar_mascara#Attributes.sufijo#" name="explicar_mascara#Attributes.sufijo#" style="border:0; font-style:italic; background-color: transparent;" size="45" tabindex="-1" readonly disabled>
					</td>
					</cfif>
				  </tr>
				</table>
			</td>
		</tr>
	<cfif Attributes.incluyeTabla>
	</table>
	</cfif>
	
	<script language="javascript" type="text/javascript">
		
		
		var valor = "";
		var tecla = "";
		var personer = "";
		var chkExtran=false;//esta variable es para saber si la persona esta escribiendo, si esta escribiendo hace que se validen los caracteres correctos para el id del extrangero
		
		function anterior#Attributes.sufijo#(){
			var f = document.forms.#Attributes.form#;
			valor = f.Pid#Attributes.sufijo#.value;
			return true;			
		}
		function getTecla#Attributes.sufijo#(e){ //Este metodo se dispara en el evento onkeyPress. NOTA: Si el browser es explorer, al parecer no se dispara el evento onkeypress cuando se presiona la tecla de borrar los shift o la tecla Control, el siguiente codigo detecta estas teclas "window.event.keyCode"
			e = (e) ? e : event
			tecla = (e.which) ? e.which : e.keyCode
			chkExtran=true;
			return true;
		}
		
		function resetMascara(){
			var f=document.forms.#Attributes.form#;
			f.Pid#Attributes.sufijo#.value="";
			return true;
		}
		
		// validaciones para mascara 9-0000-0000 persona física
		function mascaraFisica(obj,t) {
			var f=document.forms.#Attributes.form#;
			var ant = f.Pid_Ant#Attributes.sufijo#.value;
			
			if (t!=46 && t!=8){		
				// no permite que el usuario digite un '-'
				if (t==45 || t==32){obj.value =valor}
				
				
				// inserta un '-' cuando la posicio es 1 0 6
				if (obj.value.length == 1 || obj.value.length == 6){
					obj.value = obj.value + '-';
					if ( obj.value.charAt(0) == '-' ){	obj.value = valor;	}
				}
			
				if (obj.value.length < 1 ){	if ( obj.value.charAt(0) == '-'){	obj.value = valor;	}}
				
				if (obj.value.length < 6 ){
					if ( obj.value.charAt(2) == '-' || obj.value.charAt(3) == '-' || obj.value.charAt(4) == '-' || obj.value.charAt(5) == '-'){	obj.value = valor;	}
				}
				if (obj.value.length <= 11 ){
					if ( obj.value.charAt(7) == '-' || obj.value.charAt(8) == '-' || obj.value.charAt(9) == '-' || obj.value.charAt(10) == '-'){	obj.value = valor;	}
				}
				
			
				//valida que todo el formato de la mascara sea correcto
				if (obj.value.length > 1 && ant.length == 0)  {	if ( obj.value.charAt(1) != '-' ){	obj.value = obj.value.substr(0,1) + '-';}}
				
				if (obj.value.length > 6 && ant.length == 0)  {	if ( obj.value.charAt(6) != '-' ){	obj.value = obj.value.substr(0,6) + '-';}}
				
				if (obj.value.length > 11){obj.value = valor.substr(0, 11);		}
				
				
			}
			return true
		}	
		
		// validaciones para mascara X-XXX-XXXXXX persona Juridica
		function mascaraJuridica(obj,t) {
			var f=document.forms.#Attributes.form#;
			var ant = f.Pid_Ant#Attributes.sufijo#.value;
			if (t!=46 && t!=8){	
				// no permite que el usuario digite un '-'
				if (t==45 || t==32){ obj.value = valor}
				
				// inserta un '-' cuando la posicion es 1 0 5
				if (obj.value.length == 1 || obj.value.length == 5){
					obj.value = obj.value + '-';
					if ( obj.value.charAt(0) == '-' ){	obj.value = valor;	}	
				}
				if (obj.value.length < 1 ){	if ( obj.value.charAt(0) == '-'){	obj.value = valor;	}}
				
				if (obj.value.length < 5 ){
					if ( obj.value.charAt(2) == '-' || obj.value.charAt(3) == '-' || obj.value.charAt(4) == '-'){	obj.value = valor	}
				}
				if (obj.value.length < 12 ){
					if ( obj.value.charAt(6) == '-' || obj.value.charAt(7) == '-' || obj.value.charAt(8) == '-' || obj.value.charAt(9) == '-' || obj.value.charAt(10) == '-' || obj.value.charAt(11) == '-'){	obj.value = valor;	}
				}
				//valida que todo el formato de la mascara sea correcto
				if (obj.value.length > 1 && ant.length == 0){	if ( obj.value.charAt(1) != '-' ){	obj.value = obj.value.substr(0,1) + '-';}}
				if (obj.value.length > 5 && ant.length == 0){	if ( obj.value.charAt(5) != '-' ){	obj.value = obj.value.substr(0,5) + '-';}}
				if (obj.value.length > 12){obj.value = valor.substr(0, 12); }
			}
			return true
		}
		
		// validaciones para mascara XXX-XXXXXX-XXXXXX Extrangero Residente
		function mascaraResidente(obj,t) {
			var f=document.forms.#Attributes.form#;
			var ant = f.Pid_Ant#Attributes.sufijo#.value;
	
			if (t!=46 && t!=8){	
				// no permite que el usuario digite un '-'
				if (t==45 || t==32){obj.value =valor}
				
				// inserta un '-' cuando la posicion es 3 0 10
				if (obj.value.length == 3 || obj.value.length == 10){
					obj.value = obj.value + '-';
					if ( obj.value.charAt(0) == '-' ){	obj.value = valor;	}
				}
				if (obj.value.length <= 3 ){	if ( obj.value.charAt(0) == '-' || obj.value.charAt(1) == '-' || obj.value.charAt(2) == '-'){	obj.value = valor;	}}
				
				if (obj.value.length <= 10 ){
					if ( obj.value.charAt(4) == '-' || obj.value.charAt(5) == '-' || obj.value.charAt(6) == '-' || obj.value.charAt(7) == '-' || obj.value.charAt(8) == '-' || obj.value.charAt(9) == '-'){	obj.value = valor;	}
				}
				if (obj.value.length <= 17 ){
					if ( obj.value.charAt(11) == '-' || obj.value.charAt(12) == '-' || obj.value.charAt(13) == '-' || obj.value.charAt(14) == '-' || obj.value.charAt(15) == '-' || obj.value.charAt(16) == '-'){	obj.value = valor;	}
				}
				//valida que todo el formato de la mascara sea correcto
				if (obj.value.length > 3 && ant.length == 0){	if ( obj.value.charAt(3) != '-' ){	obj.value = obj.value.substr(0,3) + '-';}}
				if (obj.value.length > 10 && ant.length == 0){	if ( obj.value.charAt(10) != '-' ){	obj.value = obj.value.substr(0,10) + '-';}}
				if (obj.value.length > 17){obj.value = valor.substr(0, 17); }
			}	
			return true
		}
		
		// validaciones para mascara [A-Z][0-9] Extrangero
		function mascaraExtranjero(obj,t) {
			
			var bien=false;
			if( (t==8) ||((t>=48) && (t<=57)) ||((t>=65) && (t<=90)) ||((t>=97) && (t<=122)) ){bien=true;}<!---solo permite borrar, numeros, mayusculas y minusculas--->
			if (bien == false){ obj.value = valor }	
		 	if (obj.value.length > 18){obj.value = valor.substr(0, 18); }
			return true
		}
		
		//Permite solamente digitar numeros (se usa en el evento onKeyPress)
		function PintaGuiones#Attributes.sufijo#(){
			var f = document.forms.#Attributes.form#;
			var obj = f.Pid#Attributes.sufijo#;
			<cfif not Attributes.ocultarPersoneria> 
				var p = f.Ppersoneria#Attributes.sufijo#.value;
			<cfelse>								
				var p = f.Ppersoneriap#Attributes.sufijo#.value;
			</cfif>
			var t=tecla;
			
			
			if(p=='F'){mascaraFisica(obj,t);}				// validaciones para mascara X-XXXX-XXXX persona física
			if(p=='J'){mascaraJuridica(obj,t);}				// validaciones para mascara X-XXX-XXXXXX persona Juridica
			if(p=='R'){mascaraResidente(obj,t);}			// validaciones para mascara XXX-XXXXXX-XXXXXX Extrangero Residente
			if(p=='E'){mascaraExtranjero(obj,t);}			// validaciones para mascara [A-Z][0-9] Extrangero
			
			return true
		}//fin de PintaGuiones
		
		//Busca si existen '-' en el string que se envia como parametro.
		function sinGuiones(tex,size){
			var sing=true;
			for(i=0; i<size; i++){
				if(tex.charAt(i)=='-'){
					sing=false;
					break;
				}
			}
			if (sing)return true;
			else return false;
		}
		
		//se usa cuando se traen valores por medio del conlist para que la identificacion se presente con su respectiva mascara segun su formato.
		function formatMascara#Attributes.sufijo#(){
			var mascara=false;
			var f = document.forms.#Attributes.form#;
			<cfif not Attributes.ocultarPersoneria>
				var p = f.Ppersoneria#Attributes.sufijo#.value;
			<cfelse>
				var p = f.Ppersoneriap#Attributes.sufijo#.value;
			</cfif>
			var obj= f.Pid#Attributes.sufijo#;
			
			if(obj.value!="" && sinGuiones(obj.value,obj.value.length)){
				if(p=='F' && obj.value.length==9){		// validaciones para mascara X-XXXX-XXXX persona física
					f.Pid#Attributes.sufijo#.value = obj.value.charAt(0) + '-' + obj.value.substr(1,4) + '-' + obj.value.substr(5,4);
					mascara=true;
				}
				if(p=='J' && obj.value.length==10){		// validaciones para mascara X-XXX-XXXXXX persona Juridica
					f.Pid#Attributes.sufijo#.value = obj.value.charAt(0) + '-' + obj.value.substr(1,3) + '-' + obj.value.substr(4,6);
					mascara=true;
				}
				if(p=='R' && obj.value.length==15){		// validaciones para mascara XXX-XXXXXX-XXXXXX Extrangero Residente
					f.Pid#Attributes.sufijo#.value = obj.value.substr(0,3) + '-' + obj.value.substr(3,6) + '-' + obj.value.substr(9,6);
					mascara=true;
				}
				
				if(p=='E'){
					if(chkExtran==false){
						mascara=true;
					}
				}
				<!---if(p=='E' && obj.value.length==4){		// validaciones para mascara [A-Z][0-9] Extrangero
					f.Pid#Attributes.sufijo#.value = '[' + obj.value.charAt(0) + '-' + obj.value.charAt(1) + '][' + obj.value.charAt(2)  + '-' + obj.value.charAt(3)+ ']';
					mascara=true;
				}--->
				
			}
			return mascara;
		}

		//se usa cuando al hacer submit para enviar la identificacion sin mascara(sin guiones: 1-234-1234 = 12341234).
		function eliminaMascara#Attributes.sufijo#(){
			var f = document.forms.#Attributes.form#;
			var id = f.Pid#Attributes.sufijo#.value;
			
			for(i=0; i<id.length; i++){
				if(id.charAt(i)=='-')id = id.replace('-', '');
				if(id.charAt(i)=='[')id = id.replace('[', '');
				if(id.charAt(i)==']')id = id.replace(']', '');
			}
			
			f.PidSinMask#Attributes.sufijo#.value = id;
			f.Pid#Attributes.sufijo#.value = id;
		}
		
		function mascaraTotal#Attributes.sufijo#(){
			var f = document.forms.#Attributes.form#;
			
			if((tecla == "") && ( window.event!= undefined))tecla = window.event.keyCode;  //en caso de q el browser sea IExplorer y que las teclas presionadas sean la de borrar, shift o alguna de las q no disparan el evento onkeyPress
			if(formatMascara#Attributes.sufijo#()==false) //revisa si se puso un identificador sin mascara para pornerle su mascara correspondiente, si se le pone mascara, no es necesaria la validacion (esta funcion se usa para el modo cambio)
			{	
				
				PintaGuiones#Attributes.sufijo#(); //pinta los guiones automaticamente segun la personeria
			}
			chkExtran=false;
			tecla="";
		}
	</script>



	<cfif not Attributes.ocultarPersoneria>
	<script language="javascript" type="text/javascript">
		
		TPTipoIdent_regex#Attributes.sufijo# = {<cfloop query="rsTipoIdentificacion"><cfif Len(Trim(Pregex))>
			'#JSStringFormat(Ppersoneria)#':/#Pregex#/, </cfif></cfloop>
			dummy: 0
			};
		TPTipoIdent_mascaras#Attributes.sufijo# = {<cfloop query="rsTipoIdentificacion"><cfif Len(Trim(Pregex))>
			'#JSStringFormat(Ppersoneria)#':'#JSStringFormat(PetiquetaCaptura)#', </cfif></cfloop>
			dummy: 0
			}
		
		function validar_identificacion#Attributes.sufijo#() {
			var f = document.forms.#Attributes.form#;
			if (!(f && f.Pid#Attributes.sufijo#)) return; // regresa true si la identificacion es valida o si no esta restringida
			
			
			mascaraTotal#Attributes.sufijo#(); //pinta los guiones automaticamente segun la personeria y la mascara del modo cambio en caso de que se dé
			
			var ident = f.Pid#Attributes.sufijo#.value;
			var tipoid = f.Ppersoneria#Attributes.sufijo#.value;
			var mascara = TPTipoIdent_regex#Attributes.sufijo#[tipoid];
			
			var imal = document.all ? document.all.img_ident_mal#Attributes.sufijo# : document.getElementById('img_ident_mal#Attributes.sufijo#');
			
			var iok = document.all ? document.all.img_ident_ok#Attributes.sufijo# : document.getElementById('img_ident_ok#Attributes.sufijo#');
			var iblank = document.all ? document.all.img_ident_blank#Attributes.sufijo# : document.getElementById('img_ident_blank#Attributes.sufijo#');
			iok.style.display  = ident.length && mascara && mascara.test(ident) ? '' : 'none';
			imal.style.display = ident.length && mascara && !mascara.test(ident) ? '' : 'none';
			iblank.style.display = ident.length ? 'none' : '';
			f.explicar_mascara#Attributes.sufijo#.value = TPTipoIdent_mascaras#Attributes.sufijo#[tipoid]?'Capturar como: '+TPTipoIdent_mascaras#Attributes.sufijo#[tipoid]:'';
			return (!mascara) || mascara.test(ident);	
		}
		
		
		validar_identificacion#Attributes.sufijo#();
		
	</script>
	</cfif>
	
	
</cfoutput>
