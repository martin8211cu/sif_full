<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de Prepago de Tarjeta Prepago --->
<cfparam	name="Attributes.agente"			type="string"	default="">						<!--- Nombre del campo que contiene el Id de Agente por el cual se van a filtrar las tarjetas prepago --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.funcion" 			type="string"	default="">						<!--- funcion a invocar despues de seleccionar en el conlis --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- se usa para indicar si se muestra en modo consulta --->
<cfparam 	name="Attributes.permNuevo" 		type="boolean"	default="false">				<!--- se usa para indicar si se elimina o no el evento onBlur del campo editable --->
<cfparam	name="Attributes.filtrarEstados"	type="string"	default="">						<!--- Se usa para filtrar los tipos de estados de las tarjetas prepago, se envían los códigos que se desean mostrar --->

<cfset ExistePrepago = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfset filtrarEstados = Attributes.filtrarEstados>
<cfif Len(Trim(filtrarEstados))>
	<cfset filtrarEstados = "'" & Replace(filtrarEstados, ",", "','", 'all') & "'">
</cfif>

<cfif Attributes.readOnly and not ExistePrepago>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo id">
</cfif>

<cfif ExistePrepago>
	<cfquery name="rsPrepago" datasource="#Attributes.Conexion#">
			Select a.PQcodigo, 
			paq.PQnombre,
			case a.TJestado
				when '0' then 'Generada'
				when '1' then 'Activa'
				when '2' then 'En Uso'
				when '3' then 'Consumida'
				when '4' then 'Vencida'
				when '5' then 'Bloqueada'
				when '6' then 'Anulada'
			end descTJestado,
			a.TJestado,
			a.TJid, 
			a.AGid as AGidPrep, 
			ag.Pquien as PquienPrep,
		   	case p.Ppersoneria 
				when 'J' then  p.PrazonSocial
				else  rtrim(rtrim(p.Pnombre) || ' ' || rtrim(p.Papellido) || ' ' || p.Papellido2) 
		   	end as nom_razon,
			p.Pid as PidPrep,
			a.TJlogin, 
			a.TJpassword, 
			a.TJgeneracion, 
			a.TJliquidada, 
			convert(varchar,a.TJuso, 103) as TJuso, 
			a.TJvigencia, 
			a.TJprecio, 
			a.TJoriginal, 
			a.TJdsaldo, 
			a.BMUsucodigo, 
			a.ts_rversion,
			(select Msimbolo from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#"> 
					and Miso4217 = (select min(Miso4217) 
				from ISBprefijoPrepago x 
			 where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
			    and x.prefijo = substring(a.TJlogin,1,char_length(x.prefijo))))
			 as Moneda
		from ISBprepago a
			inner join ISBpaquete paq
				on paq.PQcodigo=a.PQcodigo
					and paq.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
					
			left outer join ISBagente ag
				on ag.AGid=a.AGid
					and ag.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">

			left outer join ISBpersona p
				on p.Pquien=ag.Pquien
		where a.TJid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		<cfif Len(Trim(filtrarEstados))>
		 	and a.TJestado in (#preserveSingleQuotes(filtrarEstados)#)
		</cfif>		
	</cfquery>
	<cfset ExistePrepago = (rsPrepago.recordCount GT 0)>
</cfif>

<cfset array = ArrayNew(1)>
<cfif ExistePrepago>
	<cfset temp = ArraySet(array, 1, 16, "")>
	<cfset array[1] = rsPrepago.TJid>
	<cfset array[2] = rsPrepago.TJlogin>
	<cfset array[3] = rsPrepago.PQcodigo>
	<cfset array[4] = rsPrepago.PQnombre>
	<cfset array[5] = rsPrepago.descTJestado>	
	<cfset array[6] = rsPrepago.TJuso>
	<cfset array[7] = rsPrepago.TJvigencia>
	<cfset array[8] = rsPrepago.TJprecio>
	<cfset array[9] = rsPrepago.TJoriginal>
	<cfset array[10] = rsPrepago.TJdsaldo>
	<cfset array[11] = rsPrepago.TJliquidada>
	<cfset array[12] = rsPrepago.PquienPrep>	
	<cfset array[13] = rsPrepago.nom_razon>	
	<cfset array[14] = rsPrepago.PidPrep>
	<cfset array[15] = rsPrepago.AGidPrep>			
	<cfset array[16] = rsPrepago.TJestado>
</cfif>

<cfset filtro = "">
<cfif Len(Trim(Attributes.agente))>
	<cfset filtro = filtro & " and a.AGid = $#Attributes.agente#,numeric$">
</cfif>
<cfif Len(Trim(filtrarEstados))>
	<cfset filtro = filtro & " and a.TJestado in (#preserveSingleQuotes(filtrarEstados)#) ">
</cfif>

<cfif ExistePrepago and Attributes.readOnly>
	<cfoutput>
		<input type="hidden" name="TJid#Attributes.sufijo#" id="TJid#Attributes.sufijo#" value="#rsPrepago.TJid#" />
		<input type="hidden" name="TJlogin#Attributes.sufijo#" id="TJlogin#Attributes.sufijo#" value="#rsPrepago.TJlogin#" />
		<input type="hidden" name="PQcodigo#Attributes.sufijo#" id="PQcodigo#Attributes.sufijo#" value="#rsPrepago.PQcodigo#" />		
		<input type="hidden" name="PQnombre#Attributes.sufijo#" id="PQnombre#Attributes.sufijo#" value="#rsPrepago.PQnombre#" />		
		<input type="hidden" name="descTJestado#Attributes.sufijo#" id="descTJestado#Attributes.sufijo#" value="#rsPrepago.descTJestado#" />				
		<input type="hidden" name="TJuso#Attributes.sufijo#" id="TJuso#Attributes.sufijo#" value="#rsPrepago.TJuso#" />
		<input type="hidden" name="TJvigencia#Attributes.sufijo#" id="TJvigencia#Attributes.sufijo#" value="#rsPrepago.TJvigencia#" />		
		<input type="hidden" name="TJprecio#Attributes.sufijo#" id="TJprecio#Attributes.sufijo#" value="#rsPrepago.TJprecio#" />				
		<input type="hidden" name="TJoriginal#Attributes.sufijo#" id="TJoriginal#Attributes.sufijo#" value="#rsPrepago.TJoriginal#" />
		<input type="hidden" name="TJdsaldo#Attributes.sufijo#" id="TJdsaldo#Attributes.sufijo#" value="#rsPrepago.TJdsaldo#" />		
		<input type="hidden" name="TJliquidada#Attributes.sufijo#" id="TJliquidada#Attributes.sufijo#" value="#rsPrepago.TJliquidada#" />
		<input type="hidden" name="PquienPrep#Attributes.sufijo#" id="PquienPrep#Attributes.sufijo#" value="#rsPrepago.PquienPrep#" />		
		<input type="hidden" name="nom_razon#Attributes.sufijo#" id="nom_razon#Attributes.sufijo#" value="#rsPrepago.nom_razon#" />		
		<input type="hidden" name="PidPrep#Attributes.sufijo#" id="PidPrep#Attributes.sufijo#" value="#rsPrepago.PidPrep#" />				
		<input type="hidden" name="AGidPrep#Attributes.sufijo#" id="AGidPrep#Attributes.sufijo#" value="#rsPrepago.AGidPrep#" />
		<input type="hidden" name="TJestado#Attributes.sufijo#" id="TJestado#Attributes.sufijo#" value="#rsPrepago.TJestado#" />
		<input type="hidden" name="Moneda#Attributes.sufijo#" id="Moneda#Attributes.sufijo#" value="#rsPrepago.Moneda#" />
		#rsPrepago.TJlogin#
	</cfoutput>
<cfelse>
	<cf_conlis 
		title="Tarjetas Prepago"
		campos = "TJid#Attributes.sufijo#,
				 TJlogin#Attributes.sufijo#,
				 PQcodigo#Attributes.sufijo#,
				 PQnombre#Attributes.sufijo#,
				 descTJestado#Attributes.sufijo#,
				 TJuso#Attributes.sufijo#,
				 TJvigencia#Attributes.sufijo#,
				 TJprecio#Attributes.sufijo#,
				 TJoriginal#Attributes.sufijo#,
				 TJdsaldo#Attributes.sufijo#,
				 TJliquidada#Attributes.sufijo#,
				 PquienPrep#Attributes.sufijo#,
				 nom_razon#Attributes.sufijo#,
				 PidPrep#Attributes.sufijo#,
				 AGidPrep#Attributes.sufijo#,
				 TJestado#Attributes.sufijo#"
		desplegables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N" 
		modificables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N"
		size = "0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
		tabla="ISBprepago a
				inner join ISBpaquete paq
					on paq.PQcodigo=a.PQcodigo
						and paq.Ecodigo=#Attributes.Ecodigo#
						
				left outer join ISBagente ag
					on ag.AGid=a.AGid
						and ag.Ecodigo=#Attributes.Ecodigo#
	
				left outer join ISBpersona p
					on p.Pquien=ag.Pquien"
		columnas="
				a.PQcodigo as PQcodigo#Attributes.sufijo#, 
				paq.PQnombre as PQnombre#Attributes.sufijo#,
				a.TJid as TJid#Attributes.sufijo#,
				a.TJlogin as TJlogin#Attributes.sufijo#, 
				case a.TJestado
					when '0' then 'Cerrada'
					when '1' then 'Activa'
					when '2' then 'En Uso'
					when '3' then 'Consumida'
					when '4' then 'Vencida'
					when '5' then 'Bloqueada'
					when '6' then 'Anulada'
				end as descTJestado#Attributes.sufijo#,
				a.TJestado as TJestado#Attributes.sufijo#,
				convert(varchar,a.TJuso,103) as TJuso#Attributes.sufijo#,
				a.TJvigencia as TJvigencia#Attributes.sufijo#,
				a.TJprecio as TJprecio#Attributes.sufijo#,
				a.TJoriginal as TJoriginal#Attributes.sufijo#,
				a.TJdsaldo as TJdsaldo#Attributes.sufijo#,
				a.TJliquidada as TJliquidada#Attributes.sufijo#,
				ag.Pquien as PquienPrep#Attributes.sufijo#,
				case p.Ppersoneria 
					when 'J' then  p.PrazonSocial
					else  rtrim(rtrim(p.Pnombre) || ' ' || rtrim(p.Papellido) || ' ' || p.Papellido2) 
				end as nom_razon#Attributes.sufijo#,
				p.Pid as PidPrep#Attributes.sufijo#,
				a.AGid as AGidPrep#Attributes.sufijo#"
		desplegar="TJlogin#Attributes.sufijo#, TJestado#Attributes.sufijo#"
		filtro="1=1
				#preserveSingleQuotes(filtro)#"
		filtrar_por="a.TJlogin, a.TJestado"
		etiquetas="Tarjeta Prepago, Estado"
		formatos="S,S"
		align="left,center"
		asignar="TJid#Attributes.sufijo#,
				 TJlogin#Attributes.sufijo#,
				 PQcodigo#Attributes.sufijo#,
				 PQnombre#Attributes.sufijo#,
				 descTJestado#Attributes.sufijo#,
				 TJuso#Attributes.sufijo#,
				 TJvigencia#Attributes.sufijo#,
				 TJprecio#Attributes.sufijo#,
				 TJoriginal#Attributes.sufijo#,
				 TJdsaldo#Attributes.sufijo#,
				 TJliquidada#Attributes.sufijo#,
				 PquienPrep#Attributes.sufijo#,
				 nom_razon#Attributes.sufijo#,
				 PidPrep#Attributes.sufijo#,
				 AGidPrep#Attributes.sufijo#,
				 TJestado#Attributes.sufijo#"
		asignarformatos="S,S,S,S,S,S,I,M,M,M,I,N,S,S,I,S"
		funcion="#Attributes.funcion#"
		Form="#Attributes.form#"
		Conexion="#Attributes.Conexion#"
		valuesArray="#array#"
		closeOnExit="true"
		tabindex="1"
		permiteNuevo="#Attributes.permNuevo#"
		maxRowsQuery="500">
</cfif>
