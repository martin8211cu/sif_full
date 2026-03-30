<cfif IsDefined('form.eliminar')>
	<cfquery datasource="asp" name="data">
		select 1 from APInstalacion
		where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
	</cfquery>
	<cfif data.RecordCount>
		<cfthrow message="El parche no se puede eliminar, porque ya ha sido instalado">
	</cfif>
	<cftransaction>
		<cfquery datasource="asp">
			delete from APParcheSQL
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
		</cfquery>
		<cfquery datasource="asp">
			delete from APFuente
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
		</cfquery>
		<cfquery datasource="asp">
			delete from APParche
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
		</cfquery>
		<cfquery datasource="asp">
			delete from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
		</cfquery>
	</cftransaction>
	<cflocation url="admabrir.cfm">
<cfelse>
	<cfinvoke component="asp.parches.comp.parche" method="olvidar_parche" />
	
	<cfquery datasource="asp" name="data">
		select parche,nombre,creado,modificado,autor,
			pdir,pnum,psec,psub,svnrev,
			entregado,cerrado,modulo,vistas,xml,
			descripcion,instrucciones
		from APParche
		where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
	</cfquery>
	
	<cfset session.parche.info.autor = data.autor>
	<cfset session.parche.info.modulo = data.modulo>
	<cfset session.parche.info.nombre = data.nombre>
	<cfset session.parche.info.pdir = data.pdir>
	<cfset session.parche.info.pnum = data.pnum>
	<cfset session.parche.info.psec = data.psec>
	<cfset session.parche.info.psub = data.psub>
	<cfset session.parche.info.svnrev = data.svnrev>
	<cfset session.parche.info.vistas = data.vistas And True>
	<cfset session.parche.info.descripcion = data.descripcion>
	<cfset session.parche.info.instrucciones = data.instrucciones>
	<cfset session.parche.guid = data.parche>

	<cfif trim(session.parche.info.nombre) EQ "">
		<cfset session.parche.info.nombre = "Parche#session.parche.info.pnum#_#session.parche.info.psec#_#session.parche.info.pdir#_#session.parche.info.psub#">
		<cf_dbfunction name="OP_concat" returnvariable="_cat">
		<cfquery datasource="asp" name="APParcheSQL">
			update APParche
			   set nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.nombre#">
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parche#">
		</cfquery>
	</cfif>

	<cfset data_xml = data.xml>
	<cfset data_xml = Replace(data_xml, Chr(25), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(26), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(27), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(28), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(29), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(30), Chr(32), 'all')>
	<cfset data_xml = Replace(data_xml, Chr(31), Chr(32), 'all')>
	<cfset xml = XMLParse(data_xml)>
	
	<cfif StructKeyExists (xml.parche, 'importacion')>
		<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
			collectionname="importacion" collection="#session.parche.importar#" arreglo="#xml.parche.importacion#"
			keys="mapkey,EIcodigo,EIdescripcion,EImodulo,checksum" />
	</cfif>
	<cfif StructKeyExists (xml.parche, 'tabla')>
		<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
			collectionname="tabla" collection="#session.parche.tabla#" arreglo="#xml.parche.tabla#"
			keys="mapkey,nombre,esquema,contar:boolean,crdate:date" />
		<cfloop from="1" to="#ArrayLen(xml.parche.tabla)#" index="i">
			<cfset mapkey = xml.parche.tabla[i].XmlAttributes.mapkey>
			<cfset session.parche.tabla[mapkey].columna = StructNew() >
			<cfif StructKeyExists (xml.parche.tabla[i], 'columna')>
				<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
					collectionname="tabla #mapkey#.columna"
					collection="#session.parche.tabla[mapkey].columna#" arreglo="#xml.parche.tabla[i].columna#"
					keys="mapkey,nombre,tipo,nulos:boolean,longitud,decimales" />
			</cfif>
			<cfset session.parche.tabla[mapkey].indice = StructNew() >
			<cfif StructKeyExists (xml.parche.tabla[i], 'indice')>
				<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
					collectionname="tabla #mapkey#.indice"
					collection="#session.parche.tabla[mapkey].indice#" arreglo="#xml.parche.tabla[i].indice#"
					keys="mapkey,nombre,unico:boolean,agrupado:boolean" />
				<cfloop from="1" to="#ArrayLen(xml.parche.tabla[i].indice)#" index="j">
					<cfset indexkey = xml.parche.tabla[i].indice[j].XmlAttributes.mapkey>
					<cfset session.parche.tabla[mapkey].indice[indexkey].columna = StructNew()>
					<cfif StructKeyExists(xml.parche.tabla[i].indice[j], 'columna')>
						<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
							collectionname="tabla"
							collection="#session.parche.tabla[mapkey].indice[indexkey].columna#" arreglo="#xml.parche.tabla[i].indice[j].columna#"
							keys="mapkey,posicion,columna" />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
	<cfif StructKeyExists (xml.parche, 'procedimiento')>
		<cfinvoke component="asp.parches.comp.parche" method="cargar_arreglo_xml"
			collectionname="procedimiento" collection="#session.parche.procedimiento#" arreglo="#xml.parche.procedimiento#"
			keys="mapkey,nombre,dbms,esquema,crdate:date,checksum" />
	</cfif>
	
	<cfinvoke component="asp.parches.comp.parche" method="contar"/>
	<cflocation url="svnlogin.cfm">
</cfif>
