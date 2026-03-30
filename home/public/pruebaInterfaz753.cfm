<!--- Interfaz para recibir notas de credito --->
<!--- El encabezado del XML recibido es para identificar la factura de ETransacciones,
      Detalles:
               Si el detalle es esExterna='S', entonces se recibio por recuperacion, por lo que se utilizan las propiedades,
               NumDoc, CodSistema y NumLineaDet para obtener la linea de FADRecuperacion y de aqui obtener el DTlinea y ya obtener
               el registro de DTransacciones.
               Si el detalle es esExterna='N': entonces NumLineaDet es el DTlinea, por lo que realizamos las validaciones que no 
               tienen que ver con recuperacion de lineas recuperadas de sistemas externos.
      Despues de las validaciones, insertamos la nota de credito en CCENotaCredito y CCDNotaCredito y terminamos el proceso.

    -------------
      ENCABEZADO
    Ecodigo 	   numeric      Ecodigo de la empresa
    Justificacion  varchar(255) Descripcion de por que se realiza la nota de credito.
    esExterna	   char(1)     'S': Si, se recibio de una transaccion externa, 'N': NO

	------------
	  DETALLES
	NumDoc			varchar(25)
	CodSistema		varchar(10)
	NumLineaDet		
	Monto			monumericney

 --------------- VALIDACIONES A REALIZAR --------------------
    ------------
      ENCABEZADO
    1.Empresa se haya recibido, Empresa exista (Ecodigo)
    2.Caja exista
    3.Factura Exista (ETnumero,FCid,Ecodigo)
	5.Que esExterna sea 'S' o 'N'
    ------------
      DETALLES (solo si es parcial, en el encabezado )
    0. Verifica si esExterna es 'S' o 'N'
    1.Linea existe en recuperacion. (solo si es externa)
	2.Linea fue usada en una factura. (solo si es externa)
	3.Verifica que la factura en la cual fue utilizada es la misma que estan intentando anular (encabezado del xml recibido),
	  se verifica estado NO anulado de la linea.
	4.Que el tipo sea 'P' o 'T'
		4.1. Tipo es Total: No hacemos nada, pues vamos a tomar el monto total de la linea.
		4.2  Tipo es Parcial:
		   4.2.1. Es Servicio: Monto a anular es menor o igual al monto de la linea (menos el monto anulado anteriormente).
		   4.2.2  Es Articulo: Valida que monto a anular sea IGUAL al monto de la linea.
---> 

<cfoutput>

	<cf_dump var="jere">
	<cfthrow message="lajsdlfasdf">

	<cfset GvarID = 3694476>

	<!--- Obtenemos la linea del encabezado --->
	<cftransaction isolation="read_uncommitted">
		<cfquery name="E753" datasource="sifinterfaces">
			select *
			from IE753
			where ID = #GvarID#
		</cfquery>
		<cfif E753.recordCount eq 0>
			<cfthrow message="Error en Interfaz 748. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
		</cfif>
		<cfquery name="D753" datasource="sifinterfaces">
			select d.* 
			from IE753 e
			inner join ID753 d
				on e.ID = d.ID
			where e.ID = #GvarID#
		</cfquery>
		<cfif D753.recordCount EQ 0>
			<cfthrow message="Error en Interfaz 748. No se indicaron detalles en el XML, los detalles a anular son requeridos.">
		</cfif>	 
	</cftransaction>



	<cf_dump var="break_uno">


	<!-------------------------------- VALIDACIONES DEL ENCABEZADO ------------------------------------------------------------>

	 <!----------------------------------->
	 <!--- 1.Empresa exista (Ecodigo) ---->
	 <!----------------------------------->
	 <cfquery name="rsEmpresa" datasource="#session.dsn#">
	 	select Ecodigo
	 	from Empresas
	 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E753.Ecodigo#">
	 </cfquery>  
	 <cfif rsEmpresa.recordCount EQ 0>
	 	<cfthrow message="No se encontro la empresa con el Ecodigo='#E753.Ecodigo#'">
	 </cfif>
	 <!------------------------------------------------>
	 <!--- 3.Factura Exista (ETnumero,FCid,Ecodigo) --->
	 <!------------------------------------------------>
	 <cfset _tempDTlinea = 0>
	 <cfloop query="D753">
	 	<cfif _tempDTlinea EQ 0>
			 <cfquery name="_rsFADRecuperacion" datasource="#session.dsn#">
			 	select * from FADRecuperacion
			 	where NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDoc#">
			 	  and CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodSistema#">
			 	  and NumLineaDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NumLineaDet#">
			 	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">
			 	  and DTlinea is not null
			 </cfquery>
			 <cfif _rsFADRecuperacion.recordCount gt 0>
				<cfset _tempDTlinea = _rsFADRecuperacion.DTlinea>
			 </cfif>
	 	</cfif>
	 </cfloop>

	 <!--- si alguan linea esta asignada, entonces, obtenemos el ETransacciones, padre de este DTransacciones --->
	 <cfquery name="rsFactura" datasource="#session.dsn#">
	 	select e.* 
	 	from ETransacciones e
	 	inner join DTransacciones d
	 		on e.ETnumero = d.ETnumero
	 	   and e.FCid = d.FCid 
	 	   and e.Ecodigo = d.Ecodigo
	 	where d.DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_tempDTlinea#">
	 	  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">
	 </cfquery>

	 <cfif rsFactura.recordCount EQ 0>
	 	<cfthrow message="No se pudo obtener una factura que coincida con los detalles incluidos en el XML. Verificar los detalles.">
	 </cfif>


	 
	 <!------------------------------------->
	 <!--- 5.Que esExterna sea 'S' o 'N' --->
	 <!------------------------------------->
	 <cfif Len(Trim(E753.esExterna)) and (E753.esExterna EQ 'S' or E753.esExterna EQ 'N')>
	 	<cfelse>
	 		<cfthrow message="No se indico correctamente si la factura es externa o no, esExterna, Los valores validos son 'S':Si es externa, 'N':No es externa">
	 </cfif>

	 <!----------------------------------------------------->
	 <!--- Verificamos que tambien exista en HDocumentos --->
	 <!----------------------------------------------------->
	 <cfquery name="rsHistoricoFactura" datasource="#session.dsn#">
	 	select * from HDocumentos
	 	where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFactura.ETnumero#">
	 	  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFactura.FCid#">
	 	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFactura.Ecodigo#">
	 </cfquery>	
	 <cfif rsHistoricoFactura.recordCount EQ 0>
	 	<cfthrow message="No se pudo obtener el historico de la factura a anular (HDocumentos). ETnumero='#rsFactgura.ETnumero#', FCid='#rsFactura.FCid#' Ecodigo='#rsEmpresa.Ecodigo#'">
	 </cfif>

	<!-------------------------------- VALIDACIONES DE LOS DETALLES ------------------------------------------------------------>
	<cfloop query="D753">
		<cfif E753.esExterna EQ 'S'> <!--- es externa, por lo que, entro por recuperacion --->
				<!--------------------------------------->
				<!--- 1.Linea existe en recuperacion. --->
				<!--------------------------------------->
				<cfquery name="rsLinea" datasource="#session.dsn#">
					select coalesce(DTlinea,-1) as DTlinea from FADRecuperacion
					where NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDoc#">
					  and CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodSistema#">
					  and NumLineaDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NumLineaDet#">
				</cfquery>
				<cfif rsLinea.recordCount EQ 0>
					<cfthrow message="No se pudo Obtener la linea de recuperacion asociada a la linea solicitada. Registro No existe en FADRecuperacion. NumDoc='#NumDoc#', CodSistema='#CodSistema#', NumLineaDet='#NumLineaDet#'">
				</cfif>
				<!----------------------------------------->
				<!--- 2.Linea fue usada en una factura. --->
				<!----------------------------------------->
				<cfif rsLinea.DTlinea EQ -1>
					<cfthrow message="La linea que se intenta anular Existe en recuperacion, sin embargo, NO ha sido recuperada por ninguna factura. NumDoc='#NumDoc#', CodSistema='#CodSistema#', NumLineaDet='#NumLineaDet#'">
				</cfif>
			<cfelse> <!--- NO es externa, por lo que ya tenemos el DTlinea --->
				<cfquery name="rsLinea" datasource="#session.dsn#">
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#NumLineaDet#"> as DTlinea from dual
				</cfquery>
		</cfif>
		<!------------------------------------->
		<!--- 3.Verifica que la factura en la cual fue utilizada es la misma que estan intentando anular (encabezado del xml recibido), 
		se verifica estado NO anulado de la linea. --->
		<!------------------------------------->
		<cfquery name="rsLineaEnFactura" datasource="#session.dsn#">
			select e.ETnumero,
				   e.FCid,
				   e.Ecodigo,
				   d.DTlinea,
				   d.DTtipo,
				   coalesce(d.DTtotal,0) as DTtotal,
				   coalesce(d.MontoAnulado,0) as MontoAnulado,
				   coalesce(d.DTtotal,0) - coalesce(d.MontoAnulado,0) as MontoDisponible
			from ETransacciones e
			inner join DTransacciones d
				on e.ETnumero = d.ETnumero
			   and e.FCid = d.FCid
			   and e.Ecodigo = d.Ecodigo
			where d.DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.DTlinea#">
			  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E753.Ecodigo#">
		</cfquery>
		<cfif rsLineaEnFactura.recordCount EQ 0>
			<cfthrow message="No se pudo leer la linea de la factura deseada, DTlinea='#rsLinea.DTlinea#'">
		</cfif>

		<cfif Trim(rsFactura.ETnumero) EQ Trim(rsLineaEnFactura.ETnumero)
		  and Trim(rsFactura.FCid) EQ  Trim(rsLineaEnFactura.FCid)
		  and Trim(rsFactura.Ecodigo) EQ  Trim(rsLineaEnFactura.Ecodigo)>
			<cfelse>  	
				<cfthrow message="No todas las lineas indicadas fueron utilizadas en la misma transaccion, favor indicar lineas que fueron utilizadas en la misma transaccion.">
		</cfif>
	
		<!-------------------------------------------------------->
		<!--- 3.1. Verifica que la linea exista en el historico--->
		<!-------------------------------------------------------->
		<!--- Esta validacion se da porque, segun facturacion, cuando una factura se aplica, se guarda en HDocumentos y HDDocumentos, 
		      por lo que existe una relacion uno a uno de DTransacciones y HDDocumentos, el proceso de notas de credito,
		      recibe el id de HDDocumentos, por eso debemos obtenerlo --->
		<cfquery name="rsLineaEnHistorico" datasource="#session.dsn#">
			select hd.*
			from ETransacciones e
			inner join DTransacciones d
				on e.ETnumero = d.ETnumero
			   and e.FCid = d.FCid
			   and e.Ecodigo = d.Ecodigo
			inner join HDDocumentos hd
				on d.DTlinea = hd.DTlinea
			where d.DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaEnFactura.DTlinea#">
		</cfquery>
		<cfif rsLineaEnHistorico.recordCount EQ 0>
			<cfthrow message="No se pudo obtener la linea del historico correspondiente al DTlinea identificado en el sistema. DTlinea='#rsLineaEnFactura.DTlinea#'">
		</cfif>
		<cfif rsLineaEnHistorico.recordCount gt 1>
			<cfthrow message="Se encontro mas de una linea de historico que corresponde con el DTlinea en el sistema. DTlinea='#rsLineaEnFactura.DTlinea#'">
		</cfif>

		<!----------------------------------->
		<!--- 4.2  Tipo es Parcial: 
		   4.2.1. Es Servicio: Monto a anular es menor o igual al monto de la linea (menos el monto anulado anteriormente).
		   4.2.2  Es Articulo: Valida que monto a anular sea IGUAL al monto de la linea. --->
		<!----------------------------------->
		<!--- validamos que el monto recibido sea un montno valido --->
		<cfif not isNumeric(Monto)>
			<cfthrow message="El monto indicado en la linea, no es un monto valido. NumLineaDet='#NumLineaDet#'">
		</cfif>
		<cfswitch expression="#rsLineaEnFactura.DTtipo#">
			<cfcase value="S">
				<cfif Monto GT rsLineaEnFactura.MontoDisponible>
					<cfthrow message="El Monto a Anular no puede superar el monto disponible para anulacion(DTtotal - MontoAnulado). 
					 TotalLinea='#rsLineaEnFactura.DTtotal#'(DTtotal), MontoAnulado anteriormente='#rsLineaEnFactura.MontoAnulado#'(MontoAnulado), TotalLinea - MontoAnulado ='#rsLineaEnFactura.MontoDisponible#'(MontoDisponible), Monto que se deasea anular='#Monto#'">
				</cfif>
			</cfcase>
			<cfcase value="A">
				<cfif Monto NEQ rsLineaEnFactura.MontoDisponible>
					<cfthrow message="Las lineas de tipo articulo solo se pueden anular de forma completa. NumLineaDet='#NumLineaDet#'">
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="La linea de la factura local no corresponde con un tipo valido. los tipos validos son.DTtipo='A':Articulo / DTtipo='S':Servicio">
			</cfdefaultcase>
		</cfswitch>



		<!--- datos del elemento a anular --->
		<cfset LineaTotal = ArrayNew(1)>
		<cfset LineaTotal[1] = rsLineaEnHistorico.HDDlinea>
		<cfset LineaTotal[2] = Monto> 
		<cfset ArrayAppend(ListaTotal,LineaTotal)>
	</cfloop>

		<!--- 
		<cfelse> <!--- el encabezado es total --->
			
		<cfquery name="rsTodasLasLineas" datasource="#session.dsn#">
			select d.DTlinea,
				   hd.HDDlinea,
				   coalesce(d.DTtotal,0) - coalesce(d.MontoAnulado,0) as MontoDisponible
			from DTransacciones d
			inner join HDDocumentos hd
				on d.DTlinea = hd.DTlinea
			where d.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E753.NumeroFactura#">
			 	  and d.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaja.FCid#">
			 	  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">
		</cfquery>
		<cfif rsTodasLasLineas.recordCount EQ 0>
			<cfthrow message="Se esta intentando registrar una nota de credito TOTAL (en el encabezado se indica), sin embargo, no se logro recuperar lineas en dicho documento en el historico. (HDDocumentos). ETnumero='#E753.NumeroFactura#', FCid='#rsCaja.FCid#', Ecodigo='#rsEmpresa.Ecodigo#'">
		</cfif>	
		
		<cfloop query="rsTodasLasLineas">
			<cfset LineaTotal = arrayNew(1)>
			<cfset LineaTotal[1] = rsTodasLasLineas.HDDlinea>
			<cfset LineaTotal[2] = rsTodasLasLineas.MontoDisponible>
			<cfset ArrayAppend(ListaTotal,LineaTotal)>
		</cfloop>	 --->

	<!--------------------------------------------------------------------------------------------------------->
	<!------------------------ Invocamos la creacion de la nota de credito ------------------------------------>
	<!--------------------------------------------------------------------------------------------------------->
	
    <!--- verificamos que se hayan encontrado detalles --->
	<cfif ArrayLen(ListaTotal) eq 0>
		<cfthrow message="No se puede crear una nota de credito sin indicar las lineas, el proceso de validaciones no devolvio
		                  ninguna linea, verificar estado de la factura a anular y los datos suministrados.">
	</cfif>
	
	<!--- transaccion para registrar la nota de credito --->
	<cftransaction action="begin">
		
		<!--- Registrar Nota de Credito --->
		<cfinvoke component="sif.Componentes.CC_NotaCredito" method="AgregarNC" returnvariable="ENCid">
			<cfinvokeargument name="HDid" value="#rsHistoricoFactura.HDid#">
			<cfinvokeargument name="justificacion" value="#E753.Justificacion#">
			<cfinvokeargument name="lineas" value="#ListaTotal#">
			<cfinvokeargument name="esExterna" value="true">
		</cfinvoke>
		
		<!--- Cambiar estado del documento original a bloqueado --->
		<cfinvoke component="sif.Componentes.CC_NotaCredito" method="CambiarEstado">
			<cfinvokeargument name="idColumna" value="#rsHistoricoFactura.HDid#">
			<cfinvokeargument name="Tabla" value="HDocumentos">
			<cfinvokeargument name="estado" value="P">
		</cfinvoke>	

		<!--- Cambiar estado de la Nota de Credito --->
		<cfinvoke component="sif.Componentes.CC_NotaCredito" method="CambiarEstado">
			<cfinvokeargument name="idColumna" value="#ENCid#">
			<cfinvokeargument name="Tabla" value="CCENotaCredito">
			<cfinvokeargument name="estado" value="A">
		</cfinvoke>	

		<!--- NO REFACTURAMOS, SOLO POR LA APLICACION WEB --->

		<!--- guardar en bitacora --->
		<cfset MensajeBitacora="Se crea la nota de credito. Interfaz 753">
		<cfinvoke component="sif.Componentes.CC_NotaCredito" method="AgregarBitacora">
			<cfinvokeargument name="ENCid" value="#ENCid#">
			<cfinvokeargument name="Observaciones" value="#MensajeBitacora#">
		</cfinvoke>

		<cf_dump var="break_Jere">

	</cftransaction>

</cfoutput>