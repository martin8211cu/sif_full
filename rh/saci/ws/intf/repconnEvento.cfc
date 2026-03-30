<cfcomponent extends="base" namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Recibe eventos del RepConn y los distribuye">

	<cfset sdfDatetime1 = CreateObject("java", "java.text.SimpleDateFormat").init('MMM dd yyyy hh:mm:ssaa')>
	<cfset sdfDatetime2 = CreateObject("java", "java.text.SimpleDateFormat").init('yyyyMMdd HH:mm:ss:SSS')>

		<!---
		Genera una estructura como la siguiente:
			evento
				tipo: update/insert/delete
				newValues: struct con los valores insertados/actualizados
				oldValues: solo en update/delete, tiene los campos llave de la actualización
		--->
		
	<cffunction name="repconnEvento" access="public" returntype="boolean" output="true">
		<cfargument name="evento" type="string" required="yes">
		
		<cfset var eventoStruct = StructNew()>
		<cfset var eventoDoc = ''>
		<cfset var evt = ''>
		<cfset control_reset()>
		<cfset control_inicio( Arguments, 'R000', '#Len(evento)# chars' )>
		<cfset control_servicio( 'repconn' )>
		<cftry>
			<cfset eventoDoc = XMLParse(Arguments.evento)>
			<cfif IsDefined('eventoDoc.dbStream.dbEvent')>
				<!--- si es RTDS 3.1/RepConnector 2.5 --->
				<cfset evts = eventoDoc.dbStream.dbEvent.XmlChildren>
			<cfelse>
				<!--- si es RTDS 3.5/RepConnectro 15.0 --->
				<cfset evts = eventoDoc.dbStream.tran.XmlChildren>
			</cfif>
			<!---
				para obtener el enviroment de donde viene el evento:
					dbStream.XmlAttributes.enviroment === la conexión del repconnector en el replication server
					dbStream.dbEvent.XmlAttributes.eventId === un identificador único del evento
			--->
			<cfset errmsg = ''>
			<cfloop from="1" to="#ArrayLen(evts)#" index="evt_index">
				<cftry>
					<cfset evt = evts[evt_index]>
					<cfset eventoStruct = StructNew()>
					<cfset eventoStruct.tipo = 	evt.XmlName>
					<cfset eventoStruct.tabla = evt.XmlAttributes.schema>
					<cfset control_asunto ( eventoStruct.tipo & ' ' & eventoStruct.tabla )>
					<cfif eventoStruct.tipo is 'insert'>
						<cfset eventoStruct.newValues = extraeValores(evt.values)>
					<cfelseif eventoStruct.tipo is 'update'>
						<cfset eventoStruct.newValues = extraeValores(evt.values)>
						<cfset eventoStruct.oldValues = extraeValores(evt.oldValues)>
					<cfelseif eventoStruct.tipo is 'delete'>
						<cfset eventoStruct.oldValues = extraeValores(evt.oldValues)>
					</cfif>
					<cfinvoke component="repconnSelector" method="selector" evento="#eventoStruct#"/>
					<cfcatch type="any">
						<cfset control_catch( cfcatch )>
						<cfset errmsg = "#cfcatch.Message# - #cfcatch.Detail# ">
						<cfif IsDefined ('cfcatch.TagContext')>
							<cfloop from="1" to="#ArrayLen(cfcatch.TagContext)#" index="i">
								<cfset errmsg = errmsg & GetFileFromPath( cfcatch.TagContext[i].Template ) & ':' & cfcatch.TagContext[i].Line & ' '>
							</cfloop>
						</cfif>
						<cfset Request.errmsg = errmsg>
						<cflog file="repconn" text="--- return false. Error en transaccion núm #evt_index#: #errmsg#">
					</cfcatch>
					</cftry>
			</cfloop>
			<cfif Not Len(errmsg)>
				<cfset control_final( )>
			</cfif>
		<cfcatch type="any">
			<cfset control_catch( cfcatch )>
			<cfset errmsg = "#cfcatch.Message# - #cfcatch.Detail# ">
			<cfif IsDefined ('cfcatch.TagContext')>
				<cfloop from="1" to="#ArrayLen(cfcatch.TagContext)#" index="i">
					<cfset errmsg = errmsg & GetFileFromPath( cfcatch.TagContext[i].Template ) & ':' & cfcatch.TagContext[i].Line & ' '>
				</cfloop>
			</cfif>
			<cfset Request.errmsg = errmsg>
			<cflog file="repconn" text="--- return false. Error: #errmsg#">
			<cfreturn false>
		</cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="extraeValores" access="private" output="false" returntype="struct">
		<cfargument name="elem" type="xml">
		
		<cfset var i = 0>
		<cfset var retValores = StructNew()>
		<cfloop from="1" to="#ArrayLen(elem.XmlChildren)#" index="i">
			<cfset item = elem.XmlChildren[i]>
			<cfif item.XmlName is 'cell'>
				<cfset value = item.XmlText>
				<cfset type = item.XmlAttributes.type>
				<cfif Len(value)>
					<cfif type is 'BIT'>
						<cfset value = IIf(value,1,0)>
					<cfelseif type is 'DATETIME'>
						<cfif value contains 'NULL' or Not Len(value)>
							<cfset value = "">
						<cfelseif Find(Left(value, 1), '123456789')>
							<!--- Comienza por un número: 20060101 ..., 61000101, etc --->
							<cfset value = sdfDatetime2.parse(value)>
						<cfelse>
							<cfset value = sdfDatetime1.parse(value)>
						</cfif>
					</cfif>
				</cfif>
				<cfset retValores[item.XmlAttributes.name] = value>
			</cfif>
		</cfloop>
		<cfreturn retValores>
		
	</cffunction>
	
</cfcomponent>