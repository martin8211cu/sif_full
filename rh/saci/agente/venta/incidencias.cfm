<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
<cfquery name="rsPQcodigo" datasource="#session.DSN#">
		select '' as value, '-- todos --' as description, '0' as ord
	union
		select distinct  d.PQcodigo as value
			, d.PQnombre as description
			, '1'as ord 
		from ISBagenteIncidencia a
			inner join ISBproducto p
				on p.Contratoid=a.Contratoid
		
			inner join ISBpaquete d
				on  d.PQcodigo = p.PQcodigo
					and  d.Habilitado = 1
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTid#">
			and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.agente.id#">
	order by 3,2
</cfquery>

<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
<cfquery name="rsInombre" datasource="#session.DSN#">
	select '' as value, '-- todos --' as description, '0' as ord
	union
	select <cf_dbfunction name="to_char" args="Iid"> as value, Inombre as descripcion, '1'as ord
	from  ISBinconsistencias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by 3,2
</cfquery>
<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
<cfquery name="rsIEstado" datasource="#session.DSN#">
	select '' as value, '-- todos --' as description, '0' as ord
	union
	select '0' as value, 'No Resuelta' as description, '1' as ord
	union
	select '1' as value, 'Resuelta' as description, '1' as ord
	order by 3,2
</cfquery>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloAlterno">Lista de Anotaciones</td>
  </tr>
  <tr>
    <td align="center">
		<!--- LISTA --->
		<cfinvoke 
			 component="sif.Componentes.pListas" 
			 method="pLista">
				  <cfinvokeargument name="tabla" value=" ISBagenteIncidencia a
														inner join ISBinconsistencias b
															on	a.Iid = b.Iid
														inner join ISBproducto p
															on p.Contratoid=a.Contratoid
														inner join ISBpaquete d
															on  d.PQcodigo = p.PQcodigo
																and  d.Habilitado = 1"/>
				  <cfinvokeargument name="columnas" value="a.INid 
															, case a.IEstado  when '0' then 'No resuelta' else 'Resuelta' end as descIEstado 
															, a.IEstado
															, d.PQcodigo
															, d.PQnombre
															, a.Iid
															, b.Inombre
															, a.INobsCrea
															, a.AGid
															, a.CTid
															, a.Contratoid"/>
				  <cfinvokeargument name="desplegar" value="Inombre,PQnombre,descIEstado,INobsCrea"/>
				  <cfinvokeargument name="etiquetas" value="Inconsistencia,Paquete,Estado,Observacion"/>
				  <cfinvokeargument name="filtro" value="a.CTid=#url.CTid#
														and p.Contratoid=#url.Contratoid#
														and a.AGid = #session.saci.agente.id#"/>
				  <cfinvokeargument name="align" value="left,left,left,left"/>
				  <cfinvokeargument name="ajustar" value="N"/>
				  <cfinvokeargument name="maxRows" value="25"/>
				  <cfinvokeargument name="irA" value="incidencias.cfm"/>
				  <cfinvokeargument name="formName" value="lista2"/>
				  <cfinvokeargument name="conexion" value="#session.DSN#"/>
				  <cfinvokeargument name="keys" value="INid"/>
				  <cfinvokeargument name="formatos" value="S,S,S,S"/>
				  <cfinvokeargument name="showLink" value="false"/>
				  <cfinvokeargument name="mostrar_filtro" value="true"/>
				  <cfinvokeargument name="filtrar_automatico" value="true"/>
				  <cfinvokeargument name="filtrar_por" value="a.Iid,d.PQcodigo,a.IEstado,a.INobsCrea"/>
				  <cfinvokeargument name="form_method" value="get"/>
				  <cfinvokeargument name="rsinombre" value="#rsInombre#"/>
				  <cfinvokeargument name="rsdesciestado" value="#rsIEstado#"/>
				  <cfinvokeargument name="rsPQnombre" value="#rsPQcodigo#"/>
		</cfinvoke>
	</td>
  </tr>
</table>



<script language="javascript" type="text/javascript">
	function funcSalir() {
		window.close();
		return false;
	}
	function funcFiltrar(){
		document.lista2.CONTRATOID.value = "<cfoutput>#url.Contratoid#</cfoutput>";
		document.lista2.CTID.value = "<cfoutput>#url.CTid#</cfoutput>";		
		document.lista2.submit();
	}
</script>
<form name="formSalir">
	<cf_botones names="Salir" values="Salir" tabindex="1">
</form>

