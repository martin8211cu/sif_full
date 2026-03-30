<!--- Etiquetas de Traduccion --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ieps" default="IEPS" returnvariable="LB_ieps" xmlfile="Solicitudes.xml"/>
<!---  --->

<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfparam name="LvarAlmacen" default="">
<cfparam name="lvarFiltroEcodigo" default="#session.Ecodigo#">

<!----►►Obtiene todos los Almacenes de la empresa◄◄--->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Bdescripcion
	from Almacen
	where Ecodigo= #lvarFiltroEcodigo#
	order by Bdescripcion
</cfquery>

<cfquery name="rsCieps" datasource="#session.dsn#">
   select Icodigo,Ccodigo,Idescripcion
	from Impuestos a
	inner join Conceptos b
	on b.codIEPS = a.Icodigo
	where a.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsCieps2" datasource ="#session.dsn#">
	select a.Icodigo,b.Acodigo,Idescripcion
	FROM Impuestos a
	inner join Articulos b
	on b.codIEPS = a.Icodigo
	where a.Ecodigo =#session.Ecodigo#
</cfquery>

<!---►►Formular Por(0-Plan de Cuentas,1-Plan de Compras)◄◄--->
<cfquery name="rsFormularPor" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'0') as Pvalor
  	from Parametros
   where Pcodigo = 2300
     and Mcodigo = 'CG'
     and Ecodigo = #session.Ecodigo#
</cfquery>

<!---►►Parametro 5306: Indicar Cuentas Contables Manualmente◄◄--->
<cfquery name="rsPermiteCuentaManual" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor
  	from Parametros
   where Pcodigo = 5306
     and Ecodigo = #session.Ecodigo#
</cfquery>
<CFIF NOT rsPermiteCuentaManual.Recordcount>
	<CFSET rsPermiteCuentaManual.Pvalor = 'N'>
</CFIF>

<cfquery datasource="#session.DSN#" name="rsUltimoAlmacen">
    select  Alm_Aid
    from DSolicitudCompraCM
    where BMUsucodigo = #session.Usucodigo#
    and DSlinea = (select max(DSlinea) from DSolicitudCompraCM where BMUsucodigo = #session.Usucodigo#)
</cfquery>
<cfset LvarAlmacen = rsUltimoAlmacen.Alm_Aid>

<!---►►►Controlar existencias de artículos en solicitudes de requisición◄◄◄--->
<cfquery datasource="#session.DSN#" name="rsControlE">
    select Pvalor
    from Parametros
    where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 4100
</cfquery>
<!---►►►Consulta la existencia de distribuciones para la empresa◄◄◄--->
<cfquery datasource="#session.DSN#" name="rsDistribucion">
select
       CPDCid,
       CPDCcodigo,
       CPDCdescripcion,
       CPDCactivo,
       CPDCporcTotal
   from CPDistribucionCostos
		where Ecodigo=#session.Ecodigo#
		and CPDCactivo=1
</cfquery>

<cfif dataTS.CMTSconRequisicion and rsControlE.Recordcount and rsControlE.Pvalor>
	<cfset LvarExistencias="true">
<cfelse>
    <cfset LvarExistencias="false">
</cfif>

<!--- Obtiene el Impuesto Default para Activos --->
    <cfquery name="rsCheckedAct" datasource="#Session.DSN#">
        select rtrim(Icodigo) as Icodigo, Idescripcion from Impuestos where IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
<!--- /Obtiene el Impuesto Default para Activos --->

<!--- Obtiene el Impuesto Default para Servicios --->
    <cfquery name="rsCheckedSer" datasource="#Session.DSN#">
        select rtrim(Icodigo) as Icodigo, Idescripcion from Impuestos where IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
<!--- /Obtiene el Impuesto Default para Servicios --->

<!--- 1. Form --->
<cfset Valipes = 0>
<cfif dmodo neq 'ALTA'>

<!--- Valida que tenga ieps --->
	<cfquery name ="rsIeps" datasource="#session.dsn#">
		select c.ValorCalculo
		from DSolicitudCompraCM a
			inner join Impuestos c
			on  a.Ecodigo=c.Ecodigo
			and c.Icodigo=a.codIEPS
		where a.Ecodigo 		=  #session.Ecodigo#
		    and ESidsolicitud   = <cfqueryparam value="#Form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
		    and DSlinea 		= <cfqueryparam value="#Form.DSlinea#" 		 cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfif rsIeps.recordcount gt 0>
		<cfset Valipes = #rsIeps.ValorCalculo#>
	</cfif>

	<cfquery datasource="#session.DSN#" name="rsFormDetalle">
		select a.DSlinea, a.DSconsecutivo, a.Ecodigo, a.ESnumero,
               case
                when a.DStipo='S' and CPDClinea IS NOT NULL then
                (
                    select sum(DScant)
                    from DSolicitudCompraCM
                    where ESidsolicitud=a.ESidsolicitud
                    and CPDClinea=a.CPDClinea
                )
                else a.DScant
                end as DScant,
               case
                   when a.DStipo='S' and a.CPDClinea IS NOT NULL then 'D'
                   else a.DStipo
                end as DStipo,
               a.Aid, a.Alm_Aid, a.Cid, a.ACcodigo, a.ACid,
			   a.DSdescripcion, a.DSobservacion, a.DSdescalterna, a.Icodigo,a.codIEPS,
			   #LvarOBJ_PrecioU.enSQL_AS("a.DSmontoest")#,
               case
                when a.DStipo='S' and a.CPDClinea IS NOT NULL then
                (
                    select sum(DStotallinest)
                    from DSolicitudCompraCM
                    where ESidsolicitud=a.ESidsolicitud
                    and CPDClinea=a.CPDClinea
                )
                    else a.DStotallinest
                end as DStotallinest,
                a.Ucodigo, a.DSfechareq,
			   a.CFid, a.DSespecificacuenta, a.CFidespecifica,
			   a.FPAEid, a.CFComplemento,Coalesce(a.PCGDid, 0) as PCGDid,a.DSmodificable, Coalesce(a.OBOid,-1) OBOid,a.ts_rversion
			   <cfif dataTS.CMTSconRequisicion neq 1>
			   , pe.FPCCtipo
			   , pe.CFComplemento  as Complemento
			   </cfif>
			   , DScontrolCantidad,
               CPDClinea,
               CPDCid
			   ,0
    <cfif rsIeps.recordcount gt 0>
				+ ((c.ValorCalculo * DStotallinest)/100)
	</cfif>    as MontoIEPS
		from DSolicitudCompraCM a
		   <cfif dataTS.CMTSconRequisicion neq 1>
		     left outer join PCGDplanCompras pc
	           on a.PCGDid = pc.PCGDid
			 left outer join  FPEPlantilla pe
			   on pc.FPEPid = pe.FPEPid
			</cfif>
			<cfif rsIeps.recordcount gt 0>
			 inner join Impuestos c
			   on  a.Ecodigo=c.Ecodigo
			   and c.Icodigo=a.codIEPS
			</cfif>
		where a.Ecodigo 		=  #session.Ecodigo#
		  and ESidsolicitud = <cfqueryparam value="#Form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
		  and DSlinea 		= <cfqueryparam value="#Form.DSlinea#" 		 cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsFormDetalleInd">
		select DScant,DSmontoest,c.Iporcentaje, d.ValorCalculo, COALESCE(e.afectaIVA,0) as AFIvaS, COALESCE(f.afectaIVA,0) as AFIvaA,b.DStipo,
			  coalesce((DScant*DSmontoest),0) as subtotal,
			    round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2) as MotoIEPS,
			  case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			    round(DScant*DSmontoest,2)
			  else
			    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)
			  end as baseIVA,

			  case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			    round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2)
			  else
			    round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2)
			  end as IVA,

			  case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			    round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
			    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)
			  else
			    round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
			    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)
			  end as MontoT,
			  b.ECid,
			  b.DClinea,
			  t.CMTScontratos
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join CMTiposSolicitud t
				on a.Ecodigo = t.Ecodigo
				and a.CMTScodigo = t.CMTScodigo
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
			left join Impuestos d
				on a.Ecodigo=d.Ecodigo
				and b.codIEPS=d.Icodigo
			left join Conceptos e
				on e.Cid = b.Cid
			left join Articulos f
				on f.Aid= b.Aid
		 where a.Ecodigo 		=  #session.Ecodigo#
		  and b.ESidsolicitud = <cfqueryparam value="#Form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
		  and b.DSlinea 		= <cfqueryparam value="#Form.DSlinea#" 		 cfsqltype="cf_sql_numeric">
	</cfquery>

	<!--- obtiene cantidades del contrato --->
	<cfif rsFormDetalleInd.CMTScontratos EQ 1>
		<cfquery name="rsCantContrato" datasource="#Session.DSN#">
		    select DCcantcontrato, DCcantsurtida, DCcantcontrato - DCcantsurtida as CantDisp
		    from   DContratosCM
		    where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalleInd.ECid#">
		    and    DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalleInd.DClinea#">
		</cfquery>
	</cfif>

	<cfquery datasource="#session.DSN#" name="rsArticulos">
		select a.Aid, a.Acodigo, a.Adescripcion , b.Eexistencia
		from Articulos a
        	inner join Existencias b
				on b.Ecodigo = a.Ecodigo
			   and b.Aid     = a.Aid
		where a.Aid     = <cfif len(trim(rsFormDetalle.Aid))>    <cfqueryparam value="#rsFormDetalle.Aid#"     cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
         and  b.Alm_Aid = <cfif len(trim(rsFormDetalle.Alm_Aid))><cfqueryparam value="#rsFormDetalle.Alm_Aid#" cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsConceptos">
		select Cid, Ccodigo, Cdescripcion
		from Conceptos
		where Cid =	<cfif len(trim(rsFormDetalle.Cid))><cfqueryparam value="#rsFormDetalle.Cid#" cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
	</cfquery>

	<cfif len(trim(rsFormDetalle.Aid)) GT 0 and len(trim(rsForm.Mcodigo)) GT 0>
		<cfquery name="rsPreciou" datasource="#session.DSN#">
			Select #LvarOBJ_PrecioU.enSQL_AS("DCpreciou")#
			from EContratosCM ec
				inner join DContratosCM dc
					on ec.ECid=dc.ECid
						and ec.Ecodigo=dc.Ecodigo
			where ec.Ecodigo= #session.Ecodigo#
				and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.Aid#">
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
				and <cf_dbfunction name="now"> between ECfechaini and ECfechafin
		</cfquery>
		<cfif isdefined('rsPreciou') and rsPreciou.recordCount GT 0 and rsPreciou.DCpreciou EQ rsFormDetalle.DSmontoest>
			<cfset cambPrecioU = 1>
		</cfif>
	</cfif>
</cfif>
<!--- ========================================================================================================= --->
<!--- Seguridad para la Solicitud --->
<!--- ========================================================================================================= --->

<!--- Tipos de Compra --->
<cfquery name="rsTipos" datasource="#session.DSN#" >
	select CMTStarticulo, CMTSservicio, CMTSactivofijo, CMTSobras, CMTScontratos
	from CMTiposSolicitud
	where Ecodigo= #session.Ecodigo#
	and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsForm.CMTScodigo)#">
</cfquery>

<!--- El Tipo de Solicitud puede solicitar lo que esta definido aqui (la especializacion limitaria esto) --->
<cfif rsTipos.CMTStarticulo  eq 1><cfset _tipos['A'] = 1 ><cfelse><cfset _tipos['A'] = 0 ></cfif>
<cfif rsTipos.CMTSservicio 	 eq 1><cfset _tipos['S'] = 1><cfset _tipos['D'] = 1 ><cfelse><cfset _tipos['S'] = 0 ><cfset _tipos['D'] = 0 ></cfif>
<cfif rsTipos.CMTSactivofijo eq 1><cfset _tipos['F'] = 1 ><cfelse><cfset _tipos['F'] = 0 ></cfif>
<cfif rsTipos.CMTSobras 	 eq 1><cfset _tipos['P'] = 1 ><cfelse><cfset _tipos['P'] = 0 ></cfif>

<!--- Especializacion por Solicitante --->
<cfquery name="dataEspecializacion" datasource="#session.DSN#" >
	select distinct CMEtipo,
		   case when b.CMEtipo = 'A' then b.Ccodigo when b.CMEtipo = 'S' then b.CCid end as clasificacion,
		   b.ACcodigo, b.ACid
	from CMESolicitantes a
	inner join CMEspecializacionTSCF b
	on a.CMElinea=b.CMElinea
	   and b.Ecodigo= #session.Ecodigo#
	   and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(rsForm.CFid)#">
	   and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsForm.CMTScodigo)#">
	<cfif isdefined("rsForm.CMElinea") and len(trim(rsForm.CMElinea)) >
		and b.CMElinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CMElinea#">
		where a.CMElinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CMElinea#">
	</cfif>
	order by CMEtipo
</cfquery>

<cfif dataEspecializacion.recordcount eq 0>
	<!--- Especializacion por TS/CF--->
	<cfquery name="dataEspecializacion" datasource="#session.DSN#" >
		select distinct CMEtipo,
			   case when CMEtipo = 'A' then Ccodigo when CMEtipo = 'S' then CCid end as clasificacion,
			   ACcodigo, ACid
		from CMEspecializacionTSCF
		where Ecodigo= #session.Ecodigo#
		and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsForm.CMTScodigo)#">
		and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(rsForm.CFid)#">
		<cfif isdefined("rsForm.CMElinea") and len(trim(rsForm.CMElinea)) >
			and CMElinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CMElinea#">
		</cfif>
		order by CMEtipo
	</cfquery>
</cfif>

<!--- Que se puede solicitar --->
<!---
	1. Lo que diga el Tipo de Solicitud (A,F,S,P)
	2. Lo que diga la Especializacion por TS/CF (a nivel Clasificacion)
	3. Lo que diga la Especializacion por Solicitante (a nivel de Clasificacion)

	La prioridad es 3,2,1, es decir si existe 3 gana 3, sino existe 3: si existe 2 gana 2 , sino existe 2 gana 1 que siempre va a existir.
--->
<!---
<cfset _tipos['A'] = 0 >
<cfset _tipos['S'] = 0 >
<cfset _tipos['F'] = 0 >
--->

<!--- 2. Existe Especializacion por TS/CF--->
<cfset a_clasificaciones = "">
<cfset s_clasificaciones = "">
<cfset categorias = "">
<cfset clasificaciones = "">

<!--- 1. Existe especializacion ya sea por Solicitante o por TS/CF --->
<cfif dataEspecializacion.RecordCount gt 0>
	<!--- 1.1 Tipos de Item que puede solicitar --->
	<!--- 1.2 Especializacion --->
	<!--- 1.2.1 Especializacion para Articulos --->
	<cfquery name="dataEArticulo" dbtype="query">
		select clasificacion
		from dataEspecializacion
		where CMEtipo = 'A'
	</cfquery>
	<cfoutput query="dataEArticulo">
		<cfset a_clasificaciones = a_clasificaciones & "#dataEArticulo.clasificacion#,">
	</cfoutput>
	<cfif len(trim(a_clasificaciones))gt 0>
		<cfset a_clasificaciones = mid( a_clasificaciones, 1, len(a_clasificaciones)-1 )>
	</cfif>

	<!--- 1.2.2 Especializacion para Servicios --->
	<cfquery name="dataEServicio" dbtype="query">
		select clasificacion
		from dataEspecializacion
		where CMEtipo = 'S'
	</cfquery>
	<cfoutput query="dataEServicio">
		<cfset s_clasificaciones = s_clasificaciones & "#dataEServicio.clasificacion#,">
	</cfoutput>
	<cfif len(trim(s_clasificaciones))gt 0>
		<cfset s_clasificaciones = mid( s_clasificaciones, 1, len(s_clasificaciones)-1 )>
	</cfif>

	<!--- 1.2.3 Especializacion para Activos --->
	<cfquery name="dataFActivoCat" dbtype="query">
		select ACcodigo
		from dataEspecializacion
		where CMEtipo = 'F'
	</cfquery>
	<cfquery name="dataFActivoCla" dbtype="query">
		select ACid
		from dataEspecializacion
		where CMEtipo = 'F'
	</cfquery>

	<cfoutput query="dataFActivoCat">
		<cfset categorias = categorias & "#dataFActivoCat.ACcodigo#,">
	</cfoutput>
	<cfif len(trim(categorias))gt 0>
		<cfset categorias = mid( categorias, 1, len(categorias)-1 )>
	</cfif>

	<cfoutput query="dataFActivoCla">
		<cfset clasificaciones = clasificaciones & "#dataFActivoCla.ACid#,">
	</cfoutput>
	<cfif len(trim(clasificaciones))gt 0>
		<cfset clasificaciones = mid( clasificaciones, 1, len(clasificaciones)-1 )>
	</cfif>
</cfif>

<cfset a_filtro = "">
<cfif len(trim(a_clasificaciones))>
	<cfset a_filtro = " and a.Ccodigo in (#a_clasificaciones#) " >
</cfif>

<cfset s_filtro = "">
<cfif len(trim(s_clasificaciones))>
	<cfset s_filtro = " and c.CCid in (#s_clasificaciones#) " >
</cfif>

<!--- ======================================================================================================== --->
<!--- Combo Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo =  #session.Ecodigo#
	<cfif len(trim(categorias))>
		and ACcodigo in (#categorias#)
	</cfif>
</cfquery>

<!--- Combo Clasificacion --->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo= #session.Ecodigo#
	<cfif len(trim(clasificaciones))>
		and ACid in (#clasificaciones#)
	</cfif>
	order by ACcodigo, ACdescripcion
</cfquery>

<script language="JavaScript" type="text/JavaScript">

	function cambiar_tipo( tipo, origen ) {
		// limpia los campos dinamicos, todos. Solo cuando los llama del combo
		<cfoutput>

			<cfif dmodo eq 'ALTA'>
				document.form1.codIEPS.value = '';
				document.form1.Idesc2.value = '';
			</cfif>

			if(document.form1.DStipo.value == "S" && '#rsCheckedSer.recordcount#' > 0){
				var icodigo = "";
				for (var i=0; i < document.form1.Icodigo.length; i++) {
					icodigo = document.form1.Icodigo.options[i].value;
					if(icodigo == '#rsCheckedSer.Icodigo#')
					{
					 document.form1.Icodigo.selectedIndex=i;
					}
				}
			}
			else if (document.form1.DStipo.value == "F" && '#rsCheckedAct.recordcount#' > 0){
				var icodigo2 = "";
				for (var i=0; i < document.form1.Icodigo.length; i++) {
					icodigo2 = document.form1.Icodigo.options[i].value;
					if(icodigo2 == '#rsCheckedAct.Icodigo#')
					{
					 document.form1.Icodigo.selectedIndex=i;
					}
				}
			}
			else{
				document.form1.Icodigo.selectedIndex=0;
			}

		</cfoutput>
		<!---<option value="A"> Artículo </option>
<option value="S"> Servicio </option>
<option value="F"> Activo Fijo </option>
<option value="P"> Obras en Construcción </option>
<option value="D"> Distribución </option>--->
		if ( origen == 'c' ){
			//document.form1.Aid.value          = '';
			almacen()
			document.form1.Cid.value          = '';
			document.form1.Ccodigo.value      = '';
			document.form1.Cdescripcion.value = '';
		}

		// limpia la descripcion de la linea
		if (origen == 'c'){
			document.form1.DSdescripcion.value = '';
		}


		// muestra la opcion seleccionada
		var valor = new String(tipo).toUpperCase()
		var div_a      = document.getElementById("divA");
		var div_a2     = document.getElementById("divA2");
		var div_ae     = document.getElementById("divAe");
		var div_ae2    = document.getElementById("divAe2");
		var div_f2     = document.getElementById("divF2");
		var div_f3 	   = document.getElementById("divF3");
		var div_fe     = document.getElementById("divFe");
		var div_fe2    = document.getElementById("divFe2");
		var div_s 	   = document.getElementById("divS");
		var div_se     = document.getElementById("divSe");
		var div_Dist   = document.getElementById("divDist");
		var div_Dist2  = document.getElementById("divDist2");
		var div_CF     = document.getElementById("divCF");
		var div_CF2    = document.getElementById("divCF2");
    	var divObra    = document.getElementById("divObra");
		var divObraL   = document.getElementById("divObraL");


		switch ( valor ) {
		   case 'A' :
			   div_a.style.display  = '' ;
			   div_a2.style.display = '' ;
			   div_ae.style.display = '' ;
			   div_f2.style.display = 'none' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = 'none' ;
			   div_se.style.display = 'none' ;
			   div_ae2.style.display = '' ;
			   div_fe2.style.display = 'none' ;
			   div_Dist.style.display  = 'none' ;
			   div_Dist2.style.display = 'none' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible' ;

			   document.form1.Cid.value = '';
			   document.form1.Ccodigo.value = '';
			   document.form1.Cdescripcion.value = '';
				 document.form1.DSdescripcion.disabled = true;
			   break;
		   case 'F' :
			   div_a.style.display  = 'none' ;
			   div_a2.style.display = 'none' ;
			   div_ae.style.display = 'none' ;
			   div_f2.style.display = '' ;
			   div_f3.style.display = '' ;
			   div_fe.style.display = '' ;
 		       div_ae2.style.display = 'none' ;
			   div_fe2.style.display = '' ;
			   div_s.style.display  = 'none' ;
			   div_se.style.display = 'none' ;
			   div_Dist.style.display  = 'none' ;
			   div_Dist2.style.display = 'none' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible' ;

			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
			   document.form1.descalterna.value = '';
			   document.form1.Cid.value = '';
			   document.form1.Ccodigo.value = '';
			   document.form1.Cdescripcion.value = '';
				 document.form1.DSdescripcion.disabled = false;
			   break;
		   case 'S' :
			   div_a.style.display  = 'none' ;
			   div_a2.style.display = 'none' ;
			   div_ae.style.display = 'none' ;
			   div_f2.style.display = 'none' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = '' ;
			   div_se.style.display = '' ;
			   div_Dist.style.display  = 'none' ;
			   div_Dist2.style.display = 'none' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible' ;
			   div_ae2.style.display = 'none' ;
			   div_fe2.style.display = 'none' ;
			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
			   document.form1.descalterna.value = '';
				 document.form1.DSdescripcion.disabled = true;
			   break;
			 case 'D' :
			   div_a.style.display  = 'none' ;
			   div_a2.style.display = 'none' ;
			   div_ae.style.display = 'none' ;
			   div_f2.style.display = 'none' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = '' ;
			   div_se.style.display = '' ;
			   div_Dist.style.display  = '' ;
			   div_Dist2.style.display = '' ;
			   div_CF.style.visibility = 'hidden' ;
			   div_CF2.style.visibility = 'hidden' ;
			   div_ae2.style.display = 'none' ;
			   div_fe2.style.display = 'none' ;
			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
			   document.form1.descalterna.value = '';
				 document.form1.DSdescripcion.disabled = true;
			   break;
			  case 'P' :
			   div_a.style.display  = 'none' ;
			   div_a2.style.display = 'none' ;
			   div_ae.style.display = 'none' ;
			   div_f2.style.display = 'none' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = '' ;
			   div_se.style.display = '' ;
			   div_Dist.style.display  = 'none' ;
			   div_Dist2.style.display = 'none' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible' ;
			   div_ae2.style.display = 'none' ;
			   div_fe2.style.display = 'none' ;
			   divObra.style.display  = '' ;
			   divObraL.style.display = '' ;

			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
			   document.form1.descalterna.value = '';
				 document.form1.DSdescripcion.disabled = true;
			   break;

		   default :
			   div_a.style.display  = '' ;
			   div_a2.style.display = '' ;
			   div_ae.style.display = '' ;
			   div_f2.style.display   = 'none' ;
			   div_f3.style.display   = 'none' ;
			   div_fe.style.display   = 'none' ;
			   div_s.style.display    = 'none' ;
			   div_se.style.display   = 'none' ;
			   div_Dist.style.display  = 'none' ;
			   div_Dist2.style.display = 'none' ;
			   div_CF.style.visibility = 'visible' ;
			   div_CF2.style.visibility = 'visible';
			   div_ae2.style.display  = 'none' ;
			   div_fe2.style.display  = 'none' ;
		}

		return;
	}

	function cambiar_categoria( valor, selected ) {
		if ( valor!= "" ) {
			// clasificacion
			document.form1.ACid.length = 0;
			i = 0;
			<cfoutput query="rsClasificacion">
				if ( #Trim(rsClasificacion.ACcodigo)# == valor ){
					document.form1.ACid.length = i+1;
					document.form1.ACid.options[i].value = '#rsClasificacion.ACid#';
					document.form1.ACid.options[i].text  = '#rsClasificacion.ACdescripcion#';
					if ( selected == #Trim(rsClasificacion.ACid)# ){
						document.form1.ACid.options[i].selected=true;
					}
					i++;
				};
			</cfoutput>
		}
		return;
	}

	function FuncReemplzarCadenaD(){
		var mainStringD = document.form1.DSdescripcion.value;
		var replaceStrD = " ";
		var delimD = "/gi";
		var regexpD = eval("/" + '"' + delimD);
		document.form1.DSdescripcion.value = mainStringD.replace(regexpD,replaceStrD);
	}
</script>
<cfif dmodo neq 'ALTA'>
	<cfif Len(Trim(rsFormDetalle.CFid))>
		<cfquery name="dataCFDetalle" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion, CFcuentac, CFcuentainventario, CFcuentainversion
			from CFuncional
			where Ecodigo= #session.Ecodigo#
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.CFid#">
		</cfquery>
	</cfif>
</cfif>
<cfoutput>
	<cfif dmodo NEQ 'ALTA'>
		<cfset variabModo = 'C'>
	<cfelse>
		<cfset variabModo = 'A'>
	</cfif>
	<cfset LvarRead = 'false'>
	<cfif dmodo neq 'ALTA' and rsFormDetalle.PCGDid neq '' and  (rsFormDetalle.DSmodificable eq 2 or rsFormDetalle.DSmodificable eq 0 )>
	   <cfset LvarRead = 'true'>
	</cfif>
	<cfparam name="rsFormDetalle.DSmontoest" default="0">
	<cfset fechareq = "" >
	<cfset LvarMostrarCal = "false">
	<cfif dmodo neq 'ALTA'>
		<cfset fechareq = LSDateFormat(rsFormDetalle.DSfechareq,'dd/mm/yyyy') >
		<cfif dmodo neq 'ALTA' and rsFormDetalle.PCGDid neq ''>
		<cfset LvarMostrarCal = "true">
		</cfif>
	</cfif>
		<input name="bandera" 		 type="hidden" value="<cfif dmodo NEQ 'ALTA' and isdefined('cambPrecioU') and cambPrecioU EQ '1'>1<cfelse>0</cfif>">
		<cfif dmodo NEQ "ALTA">
			<cfset varDSdescalterna = trim(Replace(rsFormDetalle.DSdescalterna,chr(34),'&quot;','ALL' ))>
			<cfset varDSobservacion = trim(Replace(rsFormDetalle.DSobservacion,chr(34),'&quot;','ALL' ))>
		</cfif>
		<input name="DSdescalterna1" type="hidden" value="<cfif dmodo NEQ "ALTA">#varDSdescalterna#</cfif>" >
		<input name="DSobservacion1" type="hidden" value="<cfif dmodo NEQ "ALTA">#varDSobservacion#</cfif>" >

	<cfif dmodo EQ 'CAMBIO'>
		<input name="DSlinea"		 type="hidden" value="#rsFormDetalle.DSlinea#">
	</cfif>
	<cfset dts = "">
	<cfif dmodo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="dts">
			<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.ts_rversion#"/>
		</cfinvoke>
		<input  name="dtimestamp" 	type="hidden" value="#dts#">
	</cfif>

	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
		<!---========ROW #1(Tipo, Almacen, Categoria, servicio, Cantidad)=============--->
		<tr>
			<td align="right" ><strong>Tipo:</strong></td>
			<td nowrap>

				<select tabindex="1" name="DStipo" onChange="javascript:cambiar_tipo(this.value, 'c');habilitaCheck();habilitaPlantilla();"<cfif dmodo neq 'ALTA'>disabled</cfif>>
					<cfif rsTipos.Recordcount gt 0>
						<cfif _tipos['A'] eq 1 ><option value="A" <cfif dmodo neq 'ALTA'  and rsFormDetalle.DStipo eq 'A' and len(trim(rsFormDetalle.Aid))>selected</cfif>><cf_translate key="itemArticulo">Art&iacute;culo</cf_translate></option></cfif>
						<cfif _tipos['S'] eq 1 ><option value="S" <cfif dmodo neq 'ALTA'  and rsFormDetalle.DStipo eq 'S' and len(trim(rsFormDetalle.Cid))>selected</cfif>><cf_translate key="itemServicio">Servicio</cf_translate></option></cfif>
						<cfif _tipos['F'] eq 1 ><option value="F" <cfif dmodo neq 'ALTA'  and rsFormDetalle.DStipo eq 'F' and len(trim(rsFormDetalle.ACcodigo))>selected</cfif>><cf_translate key="itemActivo">Activo Fijo</cf_translate></option></cfif>
						<cfif _tipos['P'] eq 1 ><option value="P" <cfif dmodo neq 'ALTA'  and rsFormDetalle.DStipo eq 'P' and len(trim(rsFormDetalle.Cid))>selected</cfif>><cf_translate key="itemObra">Obras en Construcci&oacute;n</cf_translate></option></cfif>
                        <cfif _tipos['D'] eq 1 ><option value="D" <cfif dmodo neq 'ALTA'  and rsFormDetalle.DStipo eq 'D' and len(trim(rsFormDetalle.Cid)) and len(trim(rsFormDetalle.CPDCid))>selected</cfif>><cf_translate key="itemDistribucion">Distribuci&oacute;n</cf_translate></option></cfif>
					 <!---Por ahora solo por el Plan de Compras, Si se quita este if, para hacer adquisiciones de obras manuales, se tiene que modificar la generacion de la cuentas, ya que no soporta obras--->
					<!--- <cfif _tipos['P'] eq 1 and dmodo neq 'ALTA' and len(trim(rsFormDetalle.OBOid)) and rsFormDetalle.OBOid NEQ -1>
												<option value="P" selected><cf_translate key="itemObra">Obras en Construcción</cf_translate></option>
					   </cfif>--->
					</cfif>
				</select>
			</td>
			<td align="right" >
				<div id="divAe2" style="display: none ;" ><strong>Almac&eacute;n:&nbsp;</strong></div>
				<div id="divFe2" style="display: none ;" ><strong>Categor&iacute;a:&nbsp;</strong></div>
                <div id="divDist" style="display: none ;" ><strong>Distribuci&oacute;n:&nbsp;</strong></div>
			</td>
			<td nowrap width="45%" >
				<div id="divA2" style="display: none;">
                <cfif url.SC_INV NEQ -1>
                	<cfif dmodo neq 'ALTA'>
						<cf_sifalmacen id="#rsFormDetalle.Alm_Aid#"  size="15" Aid="Alm_Aid" readOnly="yes" Ecodigo="#lvarFiltroEcodigo#">
					<cfelse>
						<cf_sifalmacen size="15" Aid="Alm_Aid" Ecodigo="#lvarFiltroEcodigo#" FilUsucodigo="yes">
					</cfif>
                <cfelse>
					<cfif dmodo neq 'ALTA'>
						<cf_sifalmacen id="#rsFormDetalle.Alm_Aid#"  size="15" Aid="Alm_Aid" readOnly="yes" Ecodigo="#lvarFiltroEcodigo#">
					<cfelse>
						<cf_sifalmacen size="15" Aid="Alm_Aid" id ="#LvarAlmacen#" Ecodigo="#lvarFiltroEcodigo#">
					</cfif>
                </cfif>
				</div>
				<div id="divF2" style="display: none ;" >
					<select tabindex="1" name="ACcodigo" onChange="javascript:cambiar_categoria(this.value, '');" >
						<cfloop query="rsCategorias">
							<cfif dmodo EQ 'ALTA'>
								<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
							<cfelse>
								<option value="#rsCategorias.ACcodigo#" <cfif rsFormDetalle.ACcodigo eq rsCategorias.ACcodigo >selected</cfif> >#rsCategorias.ACdescripcion#</option>
							</cfif>
						</cfloop>
					</select>
				</div>
                <div id="divDist2" style="display:none">
                  <select tabindex="1" name="CPDCid" onChange="javascript:funcion(this.value, '');" >
						<cfloop query="rsDistribucion">
							<cfif dmodo EQ 'ALTA'>
								<option value="#rsDistribucion.CPDCid#">#rsDistribucion.CPDCcodigo# - #rsDistribucion.CPDCdescripcion#</option>
							<cfelse>
								<option value="#rsDistribucion.CPDCid#" <cfif rsFormDetalle.CPDCid eq rsDistribucion.CPDCid>selected</cfif> >#rsDistribucion.CPDCcodigo# - #rsDistribucion.CPDCdescripcion#</option>
							</cfif>
						</cfloop>
					</select>
                </div>
			</td>
			<td align="right" width="1%" valign="middle" >
				<div id="divAe" style="display: none ;" ><strong>Art&iacute;culo:&nbsp;</strong></div>
				<div id="divFe" style="display: none ;" ><strong>Clasificaci&oacute;n:&nbsp;</strong></div>
				<div id="divSe" style="display: none ;" ><strong>Servicio:&nbsp;</strong></div>
			</td>
			<td nowrap>
				<div id="divS" style="display: none ;" >
					<cfif dmodo eq 'ALTA'>
						<cf_sifconceptos filtroextra="#s_filtro#" tabindex="1" Ecodigo="#lvarFiltroEcodigo#" FuncJSalCerrar="llenar();">
					<cfelse>
						<cf_sifconceptos query="#rsConceptos#"  filtroextra="#s_filtro#" tabindex="1" Ecodigo="#lvarFiltroEcodigo#">
					</cfif>
				</div>
				<div id="divA" style="display: none ;" >
					<cfif dmodo neq 'ALTA'>
						<cf_sifarticulos Existencias="#LvarExistencias#" width="1000" SoloExistentes="#LvarExistencias#" FuncJSalCerrar="traeMonto(window.opener.document.form1.DScant.value,'C');llenar2();" query="#rsArticulos#"  almacen="Alm_Aid" filtroextra="#a_filtro#" tabindex="1" readOnly="yes" Ecodigo="#lvarFiltroEcodigo#">
					<cfelse>
						<cf_sifarticulos Existencias="#LvarExistencias#" width="1000" SoloExistentes="#LvarExistencias#" FuncJSalCerrar="traeMonto(window.opener.document.form1.DScant.value,'A');" filtroextra="#a_filtro#" almacen="Alm_Aid" tabindex="1" Ecodigo="#lvarFiltroEcodigo#">
					</cfif>
				</div>
				<div id="divF3" style="display: none ;" >
					<select name="ACid" tabindex="1" ></select>
				</div>
			</td>
			<td align="right"><strong>Cantidad:</strong>&nbsp;</td>
				<td nowrap>
					<input 	type="text"
						name="DScant"
						value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.DScant, 'none')#<cfelse>0.00</cfif>"
						tabindex="1" size="16" maxlength="16"
						style="text-align: right;"
						onFocus="javascript:GvarDScant=true;this.value=qf(this); this.select();"
						onBlur="javascript:GvarDScant=false;fm(this,2); total(); traeMonto(this.value,'#variabModo#');"
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};
						<cfif isdefined('rsFormDetalleInd.CMTScontratos') and rsFormDetalleInd.CMTScontratos EQ 1 and rsCantContrato.cantDisp GT 0>
							this.value = minmax(this.value, 0, #rsCantContrato.cantDisp#)
						</cfif>"
						<cfif dmodo neq 'ALTA' and rsFormDetalle.PCGDid and (rsFormDetalle.DSmodificable neq 2 and rsFormDetalle.DSmodificable neq 3 and rsFormDetalle.DScontrolcantidad NEQ 0)>disabled</cfif>>
						<cfif isdefined('rsFormDetalleInd.CMTScontratos') and rsFormDetalleInd.CMTScontratos EQ 1 and rsCantContrato.cantDisp GT 0>
							<font color="red"> Disponible: #rsCantContrato.cantDisp#</font>
						</cfif>
				</td>
		</tr>
		<!---ROW #2--->
			<tr>
				<td align="right"><strong>Impuesto:&nbsp;</strong></td>
					<td colspan="3">
                   		<cfset valuesarray = ArrayNew(1)>
						<cfif dmodo neq 'ALTA' or dataTS.CMTSconRequisicion NEQ 0>
                            <cfquery name="rsImpuestoSel" datasource="#session.dsn#">
                                select Icodigo, Idescripcion
                                from Impuestos
                                where Ecodigo= #session.Ecodigo#
                                <cfif dataTS.CMTSconRequisicion EQ 0>
                               		and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDetalle.Icodigo#">
                              	<cfelse>
                                    and Icodigo = coalesce((select min(Icodigo) from Impuestos where Icodigo = 'IE' and Ecodigo = #session.Ecodigo# and Iporcentaje = 0 ),(select min(Icodigo) from Impuestos where Iporcentaje = 0 and Ecodigo = #session.Ecodigo#))
                                </cfif>
                            </cfquery>
                            <cfset ArrayAppend(valuesarray,"#rsImpuestoSel.Icodigo#")>
                            <cfset ArrayAppend(valuesarray,"#rsImpuestoSel.Idescripcion#")>
                        </cfif>
                        <cfset lvarReadonly =false>
                        <cfif (dmodo neq 'ALTA' and rsFormDetalle.PCGDid neq '') or dataTS.CMTSconRequisicion NEQ 0>
                        	<cfset lvarReadonly = true>
                        </cfif>
					<cfset filt="Ecodigo = #Session.Ecodigo# and ieps is null or ieps !=1" >
                    	<cf_conlis
                            title="Lista Impuestos"
                            campos = "Icodigo, Idescripcion"
                            desplegables = "S,S"
                            modificables = "S,N"
                            readonly = "#lvarReadonly#"
                            valuesarray = "#valuesarray#"
                            size = "10,30"
                            tabla="Impuestos"
                            columnas="Icodigo, Idescripcion"
                            filtro="#filt#"
                            desplegar="Icodigo, Idescripcion"
                            etiquetas="C&oacute;digo, Descripci&oacute;n"
                            formatos="S,S"
                            align="left,left"
                            asignar="Icodigo, Idescripcion"
                            asignarformatos="S,S">
					</td>
					<td align="right"><strong>Unidad:&nbsp;</strong></td>
					<td>
                    	<cfset valuesarray = ArrayNew(1)>
						<cfif dmodo neq 'ALTA'>
                            <cfquery name="rsUnidad" datasource="#session.DSN#">
                                select rtrim(Ucodigo) as Ucodigo, Udescripcion
                                from Unidades
                                where Ecodigo= #session.Ecodigo#
                                  and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDetalle.Ucodigo#">
                               	<cfif rsFormDetalle.DStipo eq 'A'>
                                  and Utipo in (0,2)
                                <cfelse>
                                  and Utipo in (1,2)
                                </cfif>
                            </cfquery>
                            <cfset ArrayAppend(valuesarray,"#rsUnidad.Ucodigo#")>
                            <cfset ArrayAppend(valuesarray,"#rsUnidad.Udescripcion#")>
                        </cfif>
                        <cfset lvarReadonly =false>
                        <cfif ((dmodo neq 'ALTA' and rsFormDetalle.PCGDid neq '') or dataTS.CMTSconRequisicion NEQ 0) and dmodo neq 'CAMBIO'>
                        	<cfset lvarReadonly = true>
                        </cfif>
                    	<cf_conlis
                            title="Lista Unidades"
                            campos = "Ucodigo, Udescripcion"
                            desplegables = "S,S"
                            modificables = "S,N"
                            readonly = "#lvarReadonly#"
                            valuesarray = "#valuesarray#"
                            size = "10,30"
                            tabla="Unidades"
                            columnas="Ucodigo, Udescripcion"
                            filtro="Ecodigo = #Session.Ecodigo# and (Utipo = 2 or Utipo = case when 'A' = $DStipo,char$ then 0 else 1 end)"
                            desplegar="Ucodigo, Udescripcion"
                            etiquetas="C&oacute;digo, Descripci&oacute;n"
                            formatos="S,S"
                            align="left,left"
                            asignar="Ucodigo, Udescripcion"
                            asignarformatos="S,S">
					</td>
					<td align="right" nowrap><strong>Monto:</strong>&nbsp;</td>
					<td>#LvarOBJ_PrecioU.inputNumber("DSmontoest", rsFormDetalle.DSmontoest, "1",LvarRead, "", "", "total();", "")#</td>
		</tr>
		<!--- Row  --->
		<tr>

				<td align="right"><strong>#LB_ieps#:&nbsp;</strong></td>
					<td colspan="3">
                   		<cfset valuesarray = ArrayNew(1)>
						<cfif dmodo neq 'ALTA' or dataTS.CMTSconRequisicion NEQ 0>
                            <cfquery name="rsImpuestoSel2" datasource="#session.dsn#">
                                select Icodigo, Idescripcion
                                from Impuestos
                                where Ecodigo= #session.Ecodigo#
                                <cfif dataTS.CMTSconRequisicion EQ 0>
                               		and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDetalle.codIEPS#">
                              	</cfif>
                            </cfquery>
                            <cfset ArrayAppend(valuesarray,"#rsImpuestoSel2.Icodigo#")>
                            <cfset ArrayAppend(valuesarray,"#rsImpuestoSel2.Idescripcion#")>
                        </cfif>
                        <cfset lvarReadonly =false>
                        <cfif (dmodo neq 'ALTA' and rsFormDetalle.PCGDid neq '') or dataTS.CMTSconRequisicion NEQ 0>
                        	<cfset lvarReadonly = true>
                        </cfif>
					<cfset filt2="Ecodigo = #Session.Ecodigo# and ieps = 1" >
                    	 <cf_conlis
                            title="Lista Impuestos"
                            campos = "codIEPS, Idesc2"
                            desplegables = "S,S"
                            modificables = "S,N"
                            readonly = "#lvarReadonly#"
                            valuesarray = "#valuesarray#"
                            size = "10,30"
                            tabla="Impuestos"
                            columnas="Icodigo as codIEPS, Idescripcion as Idesc2"
                            filtro="#filt2#"
                            desplegar="codIEPS, Idesc2"
                            etiquetas="C&oacute;digo2, Descripci&oacute;n2"
                            formatos="S,S"
                            align="left,left"
                            asignar="codIEPS, Idesc2"
                            asignarformatos="S,S">
			</td>
			<td align="right" nowrap><strong>Requerida:</strong>&nbsp;</td>
			<td nowrap width="100%">
				<cf_sifcalendario value="#fechareq#" tabindex="1" name="DSfechareq" readOnly="#LvarMostrarCal#" >
			</td>
			<td align="right" nowrap><strong>SubTotal:</strong>&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="DStotallinest" readonly value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.DStotallinest, 'none')#<cfelse>0.00</cfif>"  size="18" maxlength="18" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>
		<!---ROW #3--->
		<tr>
			<td align="right"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td nowrap colspan="3">
			<input tabindex="1" name="DSdescripcion" size="50" maxlength="255" onkeyup="FuncReemplzarCadenaD();" value="<cfif dmodo NEQ 'ALTA'>#HTMLEditFormat(rsFormDetalle.DSdescripcion)#</cfif>" onFocus="javascript: this.select();">
			<a href="javascript:info(1);"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif dmodo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>
			</td>

        	<td align="right" nowrap>
            <div id="divCF"><strong>Centro Funcional:</strong>&nbsp;
            </div>
            </td>
			<td>
            <div id="divCF2">
            	<cfset valuesarray = ArrayNew(1)>
				<cfif dmodo neq 'ALTA' and isdefined('dataCFDetalle')>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFid#")>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFcodigo#")>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFdescripcion#")>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFcuentac#")>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFcuentainventario#")>
                    <cfset ArrayAppend(valuesarray,"#dataCFDetalle.CFcuentainversion#")>
                </cfif>
                <cfset lvarReadonly =false>
                <cfif dmodo neq 'ALTA' and len(trim(rsFormDetalle.PCGDid)) gt 0 and rsFormDetalle.PCGDid>
                    <cfset lvarReadonly = true>
                </cfif>
                <cfif isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))>
                	<cfset lvarSolicitante = session.compras.solicitante>
                <cfelse>
                	<cfset lvarSolicitante = -1>
                </cfif>
            	<cf_conlis Title="Lista de Centros Funcionales"
                    Campos="CFid_Detalle,CFcodigo_Detalle,CFdescripcion_Detalle, CFcuentac_Detalle, CFcuentainventario_Detalle, CFcuentainversion_Detalle"
                    Desplegables="N,S,S,N,N,N"
                    Modificables="N,S,N,N,N,N"
                    readonly = "#lvarReadonly#"
                    valuesarray = "#valuesarray#"
                    Size="0,10,30,0,0,0"
                    Columnas="cf.CFid as CFid_Detalle, cf.CFcodigo as CFcodigo_Detalle, cf.CFdescripcion as CFdescripcion_Detalle, es.SNcodigo as SNcodigo_Detalle, cf.CFcuentac as CFcuentac_Detalle, cf.CFcuentainventario as CFcuentainventario_Detalle, cf.CFcuentainversion as CFcuentainversion_Detalle"
                    Tabla="ESolicitudCompraCM es
                            inner join CMTiposSolicitud ts
                                on ts.CMTScodigo = es.CMTScodigo and ts.Ecodigo = es.Ecodigo
                            inner join CMTSolicitudCF scf
                                on scf.CMTScodigo = ts.CMTScodigo and scf.Ecodigo = ts.Ecodigo
                            inner join CFuncional cf
                                on cf.CFid = scf.CFid and cf.Ecodigo = scf.Ecodigo
                            inner join CMSolicitantesCF sol
                                on sol.CFid = cf.CFid"
                    Filtro="sol.CMSid = #lvarSolicitante# and es.ESidsolicitud = #form.ESidsolicitud#  and es.Ecodigo = #session.Ecodigo#
                            and es.CMTScodigo = (select rtrim(CMTScodigo) from ESolicitudCompraCM where Ecodigo = #session.Ecodigo# and ESidsolicitud = #form.ESidsolicitud#)"
                    Desplegar="CFcodigo_Detalle,CFdescripcion_Detalle"
                    Etiquetas="Codigo, Descripci&oacute;n"
                    filtrar_por="cf.CFcodigo, cf.CFdescripcion"
                    Formatos="S,S"
                    Asignar="CFid_Detalle,CFcodigo_Detalle,CFdescripcion_Detalle,CFcuentac_Detalle,CFcuentainventario_Detalle,CFcuentainversion_Detalle"
                    Asignarformatos="N,S,S,S,S,S"
                    showEmptyListMsg="true"
                />
              </div>
			</td>
			<td align="right" nowrap><strong>IEPS:</strong>&nbsp;</td>


			<td>
				<input tabindex="1" type="text" name="MontoIEPS" readonly value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.MontoIEPS, 'none')#<cfelse>0.00</cfif>"  size="18" maxlength="18" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>

		</tr>
		<!---ROW #4--->
		<tr>
			<td colspan="4">
			</td>
			<td align="left" colspan="2">
            	<cfset visible = "">
				<cfif rsPermiteCuentaManual.Pvalor EQ 'S'>
                	<strong>Especifica cuenta:</strong>
                <cfelse>
                	<cfset visible = "visibility:hidden">
                </cfif>
				<input style="border-width:0; margin:0; <cfoutput>#visible#</cfoutput>" type="checkbox" onClick="javascript:mostrarCuenta(this.checked);" name="DSespecificacuenta" <cfif dmodo neq 'ALTA' and rsFormDetalle.DSespecificacuenta eq 1>checked</cfif> <cfif dmodo neq 'ALTA' and len(trim(rsFormDetalle.PCGDid)) gt 0 >disabled</cfif> >
			</td>
			<td align="right" nowrap><strong>Base para el IVA:</strong>&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="BaseIVA" readonly value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalleInd.baseIVA, 'none')#<cfelse>0.00</cfif>"  size="18" maxlength="18" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>

<!--- JMRV. Inicio. Check de Distribucion para Articulos. 02/05/2014 --->

	<!---Obtiene la lista de distribuciones disponibles--->
	<cfquery name="rsDistribuciones" datasource="#session.DSN#">
		select CPDCid, <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  	from CPDistribucionCostos
		where Ecodigo=#session.Ecodigo#
	   	and CPDCactivo=1
	   	and Validada = 1
	</cfquery>

	<!---Obtiene la distribucion aplicada en la linea de la solicitud de compra--->
	<cfif isdefined("form.ESidsolicitud") and isdefined("Form.DSlinea")>
		<cfquery name="rsDistribucionElegida" datasource="#session.DSN#">
			select CPDCid, DStipo
	  		from DSolicitudCompraCM
			where Ecodigo =  #session.Ecodigo#
		 	and ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
		  	and DSlinea = <cfqueryparam value="#Form.DSlinea#" 	cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>

	<!---Obtiene la descripcion de la distribucion aplicada en la linea--->
	<cfif isdefined("rsDistribucionElegida.CPDCid") and len(trim(rsDistribucionElegida.CPDCid))>
		<cfquery name="rsDescripcionDistribucionElegida" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  		from CPDistribucionCostos
			where CPDCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionElegida.CPDCid#">
		</cfquery>
	</cfif>

	<td align="right" nowrap><strong id="EtiquetaDistribucion"
			<cfif _tipos['A'] eq 1>style="display:"<cfelse>style="display:none"</cfif>>Distribucion del monto:</strong></td>
	<td><input type="checkbox" name="CheckDistribucion" id="CheckDistribucion" onclick="javascript:habilitaPlantilla();cambioDeEstado();"
			<cfif isdefined("rsDistribucionElegida.DStipo") and rsDistribucionElegida.DStipo eq "A" and dmodo EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ "">checked<cfelse>unchecked</cfif>
			<cfif _tipos['A'] eq 1>style="display:"<cfelse>style="display:none"</cfif>></td>
	<input type="hidden" id="CheckDistribucionHidden" name="CheckDistribucionHidden"
			<cfif isdefined("rsDistribucionElegida.DStipo") and rsDistribucionElegida.DStipo eq "A" and dmodo EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ "">value="1"<cfelse>value="0"</cfif>>

	<td align="right" nowrap><strong id="EtiquetaPlantilla"
			<cfif (isdefined("rsDistribucionElegida.DStipo") and rsDistribucionElegida.DStipo eq "A" and dmodo EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ "")>style="display:"<cfelse>style="display:none"</cfif>
			>Distribucion:</strong></td>
	<td width="1%">
	<select name="PlantillaDistribucion" id="PlantillaDistribucion"
			<cfif (isdefined("rsDistribucionElegida.DStipo") and rsDistribucionElegida.DStipo eq "A" and dmodo EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ "")>style="display:"<cfelse>style="display:none"</cfif>>

		<cfif dmodo NEQ 'CAMBIO'>
			<option value="-1" selected>Elija una opcion...</option>
		<cfelseif dmodo EQ 'CAMBIO' and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid EQ "">
			<option value="-1" selected>Elija una opcion...</option>
		</cfif>

		<cfloop query="rsDistribuciones">
			<cfif (isdefined("rsDistribucionElegida.DStipo") and rsDistribucionElegida.DStipo eq "A" and dmodo EQ 'CAMBIO' and rsDistribucionElegida.CPDCid NEQ "")>
			<option value="#rsDistribuciones.CPDCid#" <cfif isdefined("rsDistribucionElegida.DStipo") and rsDistribuciones.CPDCid eq rsDistribucionElegida.CPDCid>selected</cfif>>#rsDistribuciones.Descripcion#</option>
			<cfelse>
			<option value="#rsDistribuciones.CPDCid#">#rsDistribuciones.Descripcion#</option>
			</cfif>
		</cfloop>
	</select>
	</td>
	</tr>


	<SCRIPT LANGUAGE="JavaScript">
		function traeValor(elemento){
			var posicion=document.getElementById(elemento).options.selectedIndex; //posicion
			var valor=document.getElementById(elemento).options[posicion].text; //valor
			return valor;
			}
		function cambioDeEstado(){

			if(document.getElementById('CheckDistribucion').checked){
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			else{
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			}
		function habilitaCheck(){
			var posicion=document.form1.DStipo.options.selectedIndex; //posicion
			var valor=document.form1.DStipo.options[posicion].text; //valor
			if(valor == "Artículo"){
				document.getElementById('CheckDistribucion').style.display = "";
				document.getElementById('EtiquetaDistribucion').style.display = "";}
			else{
				document.getElementById('CheckDistribucion').style.display = "none";
				document.getElementById('EtiquetaDistribucion').style.display = "none";}
			}
		function habilitaPlantilla(){
			var posicion=document.form1.DStipo.options.selectedIndex; //posicion
			var valor=document.form1.DStipo.options[posicion].text; //valor
			var checkActivo = (document.getElementById('CheckDistribucion').checked);
			if(valor == "Artículo" && checkActivo){
				document.getElementById('EtiquetaPlantilla').style.display = "";
				document.getElementById('PlantillaDistribucion').style.display = "";}
			else{
				document.getElementById('EtiquetaPlantilla').style.display = "none";
				document.getElementById('PlantillaDistribucion').style.display = "none";}
			}
	</SCRIPT>
<!---JMRV. Fin. Check de Distribucion para Articulos. 02/05/2014 --->


		</tr>
		<!---►►Actividad Empresarial◄◄--->
		<tr>
			<td align="right">
            	<cfif rsActividad.Pvalor eq 'S'>
                	<strong><strong>Act.Empresarial</strong>:</strong>&nbsp;
                </cfif>
			<td colspan="3">
				<cfif rsActividad.Pvalor eq 'S'>
                	<!---►►Formular por Plan de Compras◄◄--->
                	<cfif rsFormularPor.Pvalor EQ 1>
						<cfif dataTS.CMTSconRequisicion eq 0>
                            <cfif dmodo EQ 'CAMBIO' and rsFormDetalle.recordcount gt 0 and len(rtrim(rsFormDetalle.FPAEid)) gt 0 >
                              <cf_ActividadEmpresa  idActividad="#rsFormDetalle.FPAEid#" valores="#rsFormDetalle.CFComplemento#" readonly="true" etiqueta="">
                            <cfelse>
                                <cf_ActividadEmpresa etiqueta="">
                            </cfif>
                        <cfelseif dataTS.CMTSconRequisicion eq 1>
                          <cfquery name="rsActEmpresarial" datasource="#session.DSN#">
                           select FPAEid, CFComplemento
                                from FPEPlantilla
                             where Ecodigo = #session.ecodigo# and  FPEPdescripcion = 'Suministros'
                          </cfquery>
                              <cf_ActividadEmpresa  idActividad="#rsActEmpresarial.FPAEid#" valores="#rsActEmpresarial.CFComplemento#" readonly="true" etiqueta="">
                        </cfif>
                      <!---►►Formular por Plan de Cuentas◄◄--->
                      <cfelse>
                      		<cfif dmodo EQ 'CAMBIO' and rsFormDetalle.recordcount gt 0 and len(rtrim(rsFormDetalle.FPAEid)) gt 0 >
                              <cf_ActividadEmpresa  idActividad="#rsFormDetalle.FPAEid#" valores="#rsFormDetalle.CFComplemento#" readonly="false" etiqueta="">
                            <cfelse>
                                <cf_ActividadEmpresa etiqueta="">
                            </cfif>
                      </cfif>
             	</cfif>
			</td>
				<td><div id="divObraL" style="display: none ;" ><strong>Obra:</strong>&nbsp;</div></td>
				<td>
					<div id="divObra"  style="display: none ;" >
						<cfif dmodo EQ 'CAMBIO'>
							<cfif len(trim(#rsFormDetalle.OBOid#))>
								<cf_OBProyObra etiqueta="" OBOid="#rsFormDetalle.OBOid#" readonly="true">
							<cfelse>
								<cf_OBProyObra etiqueta="" OBOid="-1" readonly="true">
							</cfif>
						<cfelse>
							<cf_OBProyObra etiqueta="" OBOid="-1">
						</cfif>
					</div>
				</td>
			</tr>
		<!---ROW #6--->
		<tr id="cuenta">
			<td width="1%" nowrap align="right"><strong>Cuenta:&nbsp;</strong></td>
			<td colspan="5">
			<cfif dmodo neq 'ALTA' and len(trim(rsFormDetalle.PCGDid)) gt 0 >
				 <cfset LvarMostrarAct = "true">
			<cfelse>
				 <cfset LvarMostrarAct = "false">
			</cfif>
				<cfif dmodo neq 'ALTA' and len(trim(rsFormDetalle.CFidespecifica))>
					<cfquery name="rsCuenta" datasource="#session.DSN#">
						select CFcuenta, Ccuenta, CFdescripcion, CFformato
						  from CFinanciera f
						 where Ecodigo =  #session.Ecodigo#
							and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.CFidespecifica#">
					</cfquery>
					<cf_cuentas  Cdescripcion="Ccdescripcion" query="#rsCuenta#" readonly="#LvarMostrarAct#">
				<cfelse>
					<cf_cuentas Cdescripcion="Ccdescripcion" >
				</cfif>
			</td>
		</tr>
	</table>

	</cfoutput>
	<iframe name="clasificacion" id="clasificacion" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
	<iframe name="frcfdetalle" 	 id="frcfdetalle"	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
	<iframe name="frPreciou" 	 id="frPreciou" 	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
	<iframe name="frTotal" 		 id="frTotal" 		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
	<iframe name="frMontoDet" 	 id="frMontoDet" 	marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<cfquery name="rsImpuestorReq" datasource="#session.dsn#">
    select Icodigo, Idescripcion
    from Impuestos
    where Ecodigo= #session.Ecodigo#
      and Icodigo = coalesce((select min(Icodigo) from Impuestos where Icodigo = 'IE' and Ecodigo = #session.Ecodigo# and Iporcentaje = 0 ),(select min(Icodigo) from Impuestos where Iporcentaje = 0 and Ecodigo = #session.Ecodigo#))
</cfquery>
<script type='text/javascript' src='/cfmx/cfide/scripts/wddx.js'></script>
<script language="JavaScript1.2" >

	var id_clasificacion = ''
	<cfoutput>
		<cfif modo neq 'ALTA' >
			<cfif dmodo neq 'ALTA'>
				id_clasificacion = #rsFormDetalle.ACid#
			</cfif>

			document.form1.Alm_Aid.alt       = "El Almacén"
			document.form1.ACcodigo.alt      = "La Categoría"
			document.form1.ACid.alt          = "La Clasificacion"
			document.form1.DSdescripcion.alt = "El campo descripción del detalle"
			cambiar_tipo( document.form1.DStipo.value, 'i' );
			cambiar_categoria( document.form1.ACcodigo.value, id_clasificacion );
		</cfif>
	</cfoutput>

	function validaPrecioU(obje){
		var valor = new Number(obje.value);
		if(document.form1.bandera.value == 1){
			obje.disabled=true;
		}else{
			obje.disabled=false;
		}
	}

	function traeMonto(val, valModo){
		var numVal = new Number(val);
		var params ="";
		//Es Articulo, la cantidad ingresada es Mayor a la Existencia, el tipo de Solicitud esta marcada como requisicion y el parametros de 4100 esta encendido
		<cfif LvarExistencias>
			if(document.form1.DStipo.value == 'A' && Number(document.form1.Eexistencia_Acodigo.value) < Number(document.form1.DScant.value.replace(',','')))
			{
				alert('La cantidad supera las existencias disponibles('+document.form1.Eexistencia_Acodigo.value+').');
				document.form1.DScant.value = Number(document.form1.Eexistencia_Acodigo.value);
			}
		</cfif>
		// si es activo no hace nada de esto
		if ( document.form1.DStipo.value != 'F' && valModo == 'A'){
			if (numVal > 0){
				if(document.form1.Mcodigo.value != '' && (document.form1.Aid.value != '' || document.form1.Cid.value != '' )){
					params = "&Aid=" + document.form1.Aid.value + "&Mcodigo=" + document.form1.Mcodigo.value + "&DScant=" + val + "&sol=<cfoutput>#Form.ESidsolicitud#</cfoutput>&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>";
					document.getElementById("frPreciou").src="/cfmx/sif/cm/operacion/dContratosCMquery.cfm?form=form1"+params;
					calcular_totales()
				}else{
					alert('Debe seleccionar primero el articulo o servicio antes de definir la cantidad');
					document.form1.DScant.value = '0.00';
				}
			}
		}

		return;
	}

	function unidad(){
		document.getElementById("clasificacion").src = "articuloUnidad-query.cfm?Aid="+document.form1.Aid.value;
	}


	function traeMontoDet(){
	<cfoutput>
		var params ="";

		if ( document.form1.DSmontoest.value == '' || document.form1.DSmontoest.value == 0 || document.form1.Aid.value != ''){
				params = "&Aid=" + document.form1.Aid.value + "&Mcodigo=" + document.form1.Mcodigo.value + "&Alm_Aid=" + document.form1.Alm_Aid.value + "&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>";
				document.getElementById("frMontoDet").src="/cfmx/sif/cm/operacion/MontoDet_Query.cfm?form=form1"+params;
			}
			else{
					document.form1.DSmontoest.value = '#LvarOBJ_PrecioU.enCF(0)#';
				}
			return;
	</cfoutput>
		}

	var GvarDScant = false;
	function funcAcodigo(){
	<cfoutput>
		document.form1.DScant.value = '0.00';
		document.form1.DSmontoest.value = '#LvarOBJ_PrecioU.enCF(0)#';
		document.form1.DStotallinest.value = '0.00';
		document.form1.DSmontoest.disabled = false;

		<!---►►Se asigna los campos ocultos del conlist, a los campos en pantalla◄◄--->
		document.form1.DSdescripcion.value  = document.form1.Adescripcion.value;
		document.form1.DSdescalterna1.value = document.form1.descalterna.value;
		document.form1.DSobservacion1.value = document.form1.observaciones.value;

    	<cfif dataTS.CMTSconRequisicion NEQ 0>
			traeIcodigo('#trim(rsImpuestorReq.Icodigo)#', true);
		<cfelse>
			if(trim(document.form1.Icodigo_Acodigo.value) !='')
				traeIcodigo(document.form1.Icodigo_Acodigo.value, true);
		</cfif>
		unidad();
		traeMontoDet();
		if (GvarDScant) document.form1.DScant.select();
		calcular_totales();
		</cfoutput>
		llenar2();
	}

	function funcExtraAcodigo(){
		<cfif dataTS.CMTSconRequisicion NEQ 0>
			document.form1.Icodigo_Acodigo.value = '#trim(rsImpuestorReq.Icodigo)#';
			traeIcodigo('#trim(rsImpuestorReq.Icodigo)#', true);
		<cfelse>
			document.form1.Icodigo_Acodigo.value = '';
			document.form1.Icodigo.value = '';
		</cfif>
		calcular_totales();
	}

	function funcCcodigo(){
	<cfoutput>
		document.form1.DScant.value = '0.00';
		document.form1.DSmontoest.value = '#LvarOBJ_PrecioU.enCF(0)#';
		document.form1.DStotallinest.value = '0.00';
		document.form1.DSmontoest.disabled = false;
		document.form1.DSdescripcion.value = document.form1.Cdescripcion.value;


		var id = document.form1.Ccodigo.value;

		<cfwddx action="cfml2js" input="#rsCieps#" topLevelVariable="rsjIeps">

		var nRows = rsjIeps.getRowCount();
		if (nRows > 0) {
			for (row = 0; row < nRows; ++row) {
				 	 if (rsjIeps.getField(row, "Ccodigo") == id){
				 	 	document.form1.codIEPS.value = rsjIeps.getField(row, "Icodigo");
				 	 	document.form1.Idesc2.readonly = false;
				 	 	document.form1.Idesc2.value = rsjIeps.getField(row, "Idescripcion");
				 	 }
			}
		}
		llenar();
		traeUcodigo(document.form1.Ucodigo_Ccodigo.value,true);
	</cfoutput>
	}

	function total(){
		document.form1.DStotallinest.value = new Number(qf(document.form1.DSmontoest.value))*new Number(qf(document.form1.DScant.value));
		document.form1.MontoIEPS.value= (new Number(qf(<cfoutput>"#Valipes#"</cfoutput>)) * new Number(qf(document.form1.DStotallinest.value)))/100;

	 var val1 = <cfoutput><cfif isdefined('rsFormDetalleInd')>"#rsFormDetalleInd.AFIvaA#"<cfelse>0</cfif></cfoutput>;
	 var val2 = <cfoutput><cfif isdefined('rsFormDetalleInd')>"#rsFormDetalleInd.AFIvaS#"<cfelse>0</cfif></cfoutput>;

	if(val1 == 1 || val2 == 1){
		document.form1.BaseIVA.value = document.form1.DStotallinest.value;
	}else{
	document.form1.BaseIVA.value = new Number(qf(document.form1.MontoIEPS.value)) + new Number(qf(document.form1.DStotallinest.value));
	}
		fm(document.form1.DStotallinest,2);
		fm(document.form1.MontoIEPS,2);
		fm(document.form1.BaseIVA,2);
		calcular_totales();
	}


	function calcular_totales(){
		if ( trim(document.form1.Icodigo.value) != '' ) {
			var paramTotal = "?form=form1&ESidsolicitud="+ document.form1.ESidsolicitud.value +
			 "&DScant="+document.form1.DScant.value + "&DSmontoest="+document.form1.DSmontoest.value + "&Icodigo=" + trim(document.form1.Icodigo.value) +
			  "&codIEPS=" + trim(document.form1.codIEPS.value) + "&modo=<cfoutput>#dmodo#</cfoutput>";
			<cfif dmodo neq 'ALTA'>
				paramTotal += "&DSlinea=" + document.form1.DSlinea.value;
			</cfif>
			document.getElementById("frTotal").src="/cfmx/sif/cm/operacion/solicitudes-total.cfm" + paramTotal;
		}
		else{
			if (window.parent.document.form2) {
			<cfoutput>
		<cfif rsPreTotales.recordcount gt 0>
			window.parent.document.form2._subtotal.value = '#LSCurrencyFormat(rsTotales.subtotal,"none")#';
			window.parent.document.form2._impuesto.value = '#LSCurrencyFormat(rsTotales.impuesto,"none")#';
			window.parent.document.form2._total.value = '#LSCurrencyFormat(rsTotales.STMontoT,"none")#';
		</cfif>
			</cfoutput>
			}
			else {
				//alert(2);
				<cfoutput>
		<cfif rsPreTotales.recordcount gt 0>
				document.form2._subtotal.value = '#LSCurrencyFormat(rsTotales.subtotal,"none")#';
				document.form2._impuesto.value = '#LSCurrencyFormat(rsTotales.impuesto,"none")#';
				document.form2._total.value = '#LSCurrencyFormat(rsTotales.STMontoT,"none")#';
		</cfif>
				</cfoutput>
			}
		}
	}

	function info(index){
		//popUpWindow("Solicitudes-info.cfm" ,250,200,600,400);
		open('solicitudes-info.cfm?index='+index, 'solicitudes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=450,left=250, top=165,screenX=250,screenY=200');
	}

	function almacen(){
		document.form1.Aid.value = '';
		document.form1.Acodigo.value = '';
		document.form1.Adescripcion.value = '';
		document.form1.descalterna.value = '';
	}

	function funcAlmcodigo(){
	<cfoutput>
		document.form1.Aid.value = '';
		document.form1.Acodigo.value = '';
		document.form1.Adescripcion.value = '';
		document.form1.descalterna.value = '';
		document.form1.DScant.value = '0.00';
		document.form1.DSmontoest.value = '#LvarOBJ_PrecioU.enCF(0)#';
		document.form1.DStotallinest.value = '0.00';
		document.form1.DSmontoest.disabled = false;
		<cfif dataTS.CMTSconRequisicion NEQ 0>
			document.form1.Icodigo.value = '#trim(rsImpuestorReq.Icodigo)#';
			document.form1.Idescripcion.value = '#trim(rsImpuestorReq.Idescripcion)#';
		<cfelse>
			document.form1.Icodigo.value = '';
		</cfif>
		calcular_totales();
	</cfoutput>
	}

	function mostrarCuenta(PermiteCtaManual){
		if(PermiteCtaManual){
			document.getElementById("cuenta").style.visibility = 'visible';
		}
		else{
			document.getElementById("cuenta").style.visibility = 'hidden';
		}
	}
	// activa o desactiva la cuenta financiera
	<cfif rsPermiteCuentaManual.Pvalor EQ 'S'>
		mostrarCuenta(document.form1.DSespecificacuenta.checked);
	<cfelse>
		mostrarCuenta(false);
	</cfif>

	function llenar(){
		var id = document.form1.Ccodigo.value;
		var valor = 0;
	<cfif isdefined('rsCieps')>
		<cfoutput query = "rsCieps">
		  if ( '#Trim(rsCieps.Ccodigo)#' == id ){
					document.form1.codIEPS.value = '#rsCieps.Icodigo#';
					document.form1.Idesc2.value = '#rsCieps.Idescripcion#';
					valor = 1;
				};
		</cfoutput>
	</cfif>

			var id = document.form1.Ccodigo.value;
	<cfoutput>
		<cfwddx action="cfml2js" input="#rsCieps#" topLevelVariable="rsjIeps">

		var nRows = rsjIeps.getRowCount();
			if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
					 	 if (rsjIeps.getField(row, "Ccodigo") == id){
					 	 	document.form1.codIEPS.value = rsjIeps.getField(row, "Icodigo");
					 	 	document.form1.Idesc2.value = rsjIeps.getField(row, "Idescripcion");
					 	 	valor = 1;
					 	 }
				}
			}
	<cfif dmodo eq	'ALTA'>
		if(valor == 0){
				document.form1.codIEPS.value = '';
				document.form1.Idesc2.value   = '';
		}
	</cfif>
	</cfoutput>

	}

		function llenar2(){
		var id = document.form1.Acodigo.value;
		var valor = 0;
	<cfif isdefined('rsCieps2')>
		<cfoutput query = "rsCieps2">
		  if ( '#Trim(rsCieps2.Acodigo)#' == id ){
					document.form1.codIEPS.value = '#rsCieps2.Icodigo#';
					document.form1.Idesc2.value = '#rsCieps2.Idescripcion#';
					valor=1;
				};
		</cfoutput>

	</cfif>

			var id = document.form1.Ccodigo.value;
	<cfoutput>
		<cfwddx action="cfml2js" input="#rsCieps2#" topLevelVariable="rsjIeps2">

		var nRows = rsjIeps2.getRowCount();
			if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
					 	 if (rsjIeps2.getField(row, "Acodigo") == id){
					 	 	document.form1.codIEPS.value = rsjIeps2.getField(row, "Icodigo");
					 	 	document.form1.Idesc2.value = rsjIeps2.getField(row, "Idescripcion");
					 	 	valor=1;
					 	 }
				}
			}

		<cfif dmodo eq 'ALTA'>
			if(valor == 0){
				document.form1.codIEPS.value = '';
				document.form1.Idesc2.value   = '';
			}
		</cfif>
		</cfoutput>

	}

	function funcAlta(){
		document.form1.DSdescripcion.disabled = false;
		return true;
	}
	function funcCambio(){
		document.form1.DSdescripcion.disabled = false;
		return true;
	}
	<cfif isdefined('rsFormDetalleInd.CMTScontratos') and rsFormDetalleInd.CMTScontratos EQ 1 and rsCantContrato.cantDisp GT 0>
		function minmax(value, min, max)
		{
		    if(parseInt(value) < min || isNaN(value))
		        return 0;
		    else if(parseInt(value) > max)
		        return <cfoutput>#rsCantContrato.cantDisp#;</cfoutput>
		    else return value;
		}
	</cfif>
</script>
