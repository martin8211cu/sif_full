
<!--- Ultima Actualización FC-08-11-2011
Estructura del archivo de Envío de las Empresas afiliadas al Servicio de Transferencias del DCD del Banco Popular 
--->

<cfparam name="url.Bid" 		default="0" >
<cfparam name="url.EcodigoASP" 	default="#session.EcodigoSDC#" >
<cfparam name="url.ERNid" 	 	default="0" >

<cf_dbfunction name="OP_concat" returnvariable="concat">

<cf_dbtemp name="data_tmp" returnvariable="datos_temp" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="DEid" 		 	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="cedula" 		 type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="nombre" 		 type="char(30)"  	mandatory="no">
	<cf_dbtempcol name="fechaemi" 		 type="char(8)"		mandatory="no">
	<cf_dbtempcol name="tipo" 			 type="char(1)"		mandatory="no">
	<cf_dbtempcol name="entidad"		 type="char(3)"		mandatory="no">
	<cf_dbtempcol name="motivo"			 type="char(2)"		mandatory="no">
	<cf_dbtempcol name="moneda"			 type="char(1)"		mandatory="no">
	<cf_dbtempcol name="servicio"		 type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="idnegocio"		 type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="negocio"		 type="char(20)" 	mandatory="no">	
	<cf_dbtempcol name="centrocosto"	 type="char(4)"		mandatory="no">
	<cf_dbtempcol name="ctacliente"		 type="char(17)" 	mandatory="no">	
	<cf_dbtempcol name="monto"			 type="char(15)"	mandatory="no">	
	<cf_dbtempcol name="documento"		 type="char(20)" 	mandatory="no">	
	<cf_dbtempcol name="iddestino"		 type="char(20)" 	mandatory="no">	
	<cf_dbtempcol name="titularservicio" type="char(25)" 	mandatory="no">	
	<cf_dbtempcol name="patrono" 		 type="char(4)"		mandatory="no">	
</cf_dbtemp>


<!--- VALIDACIONES----->

<cfset Errs=''>

<!--- validando cédula jurídica--->

<cfquery name="rs_empresacedula" datasource="#session.DSN#">
	select Enombre, Eidentificacion
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfif rs_empresacedula.RecordCount GT 0>	
		<cfif not (len(trim(rs_empresacedula.Eidentificacion)) ) GT 0>
        			<cfset Errs=Errs & 'La cédula jurídica de esta Empresa  no esta definida<br>'>
                   <cfset Errs =  Errs & 'Ingrese a la Informaci&oacute;n de la Empresa (Administraci&oacute;n del Portal) y modifique la Identificaci&oacute;n<br><br><br>'>		
        </cfif>
</cfif>



<!---Validacion de la Cuenta del  patrono --->
	<cfquery name="rsPatrono" datasource="#session.DSN#">
    
	select Bcodigocli  as patrono
	
    from Bancos 
	
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Bid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">   
    and <cf_dbfunction name ="length" args="Bcodigocli "> > 0
        
	</cfquery>
		<cfset Errs2 = ''>
	<cfif rsPatrono.RecordCount GT 0>	
		<cfif len(trim(rsPatrono.patrono)) NEQ 4>
			<cfset Errs2 =  Errs2 & 'El C&oacute;digo de Patrono"'&rsPatrono.patrono&'" debe tener 4 digitos <br>'>
		</cfif>
    <cfelse>
			<cfset Errs2 =  Errs2 & 'No se ha definido el C&oacute;digo de Patrono. <br>'>
	</cfif>
    
	<cfif Errs2 NEQ ''>
			<cfset Errs =  Errs & 'Errores C&oacute;digo de Patrono<br><br>'& Errs2 & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos  y modifique los inconvenientes en el campo [C&oacute;digo de cliente]. <br><br><br>'>		
	</cfif>
    
  
  
<!--- validando cuentas empleado--->
<cfquery name="InsertDatos" datasource="#session.DSN#">
Select  de.DEidentificacion,de.DEnombre+ ' ' + de.DEapellido1  +' ' +de.DEapellido2 as empleado, de.CBcc

from 
             <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
             		ERNomina b  inner join  DRNomina a
             <cfelse>
             		HERNomina b  inner join  HDRNomina a
             </cfif>
				on a.ERNid = b.ERNid
			  inner join  DatosEmpleado de
				on de.DEid = a.DEid

Where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and de.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	and a.ERNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
      <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
           and a.DRNestado =1 <!---si es una nomina en proceso y  DRNestado es 1 para mostrar los empleados que se les pagarán, de lo contrario el valor sería 2=no se pagaran---->
     <cfelse>
            and a.HDRNestado =1 <!---si es una nomina en historico y  HDRNestado es 1 para mostrar los empleados que se les pagarán, de lo contrario el valor sería 2=no se pagaran---->
       </cfif>
</cfquery>

	<cfset Errs3 = ''>	
	<cfloop query="InsertDatos">
		<cfif len(trim(InsertDatos.CBcc)) NEQ 17>
			<cfset Errs3 =  Errs3 & 'La [Cuenta  Cliente]: #InsertDatos.CBcc# <br>  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#, no cumple con la cantidad de digitos deseados (17). <br>'>
		</cfif>
	</cfloop>
    
	<cfif Errs3 NEQ ''>
		<cfset Errs3 =  Errs3 & 'Corriga los inconvenientes en el Cat&aacute;logo de Empleados, en el campo [Cuenta Cliente] <br><br>'>
		<cfset Errs = Errs & 'Errores Cuentas de los Empleados<br><br>' & Errs3>
	</cfif>

<!--- mensaje de error en caso que existan errores--->
	<cfif len(trim(Errs))>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
		<cfabort>
	</cfif>
    


<!--------------------------------------------------------------- FORMATEO DE CAMPOS PreConsulta -------------------------------------------------------------------------------->


<!--- recupera la cedula juridica de la empresa (campo Eidentificacion de la vista Empresa ) --->
<cfset cedula_juridica = mid(rs_empresacedula.Eidentificacion, 1, 20) >
<cfset empresa = mid(rs_empresacedula.Enombre, 1, 20) >


 <!--- Formateo Cedula -: cedula del cliente Destino a quien se le va a relizar el credito--->
 <!---Longitud : 10--->
	<cf_dbfunction name="string_part" args="de.DEidentificacion|1|10" 	returnvariable="LvarSPCedula"  delimiters="|"> <!--- Primero 10 caracteres--->

 
 <!--- Formateo Nombre : Nombre del Cliente Destino --->
 <!---Se desea: Solo letras, sin tildes, eñes, o signos de puntuacion.  Orden: 1apellido, 2apellido, Nombre--->
  <!---Longitud : 30--->
  
  <cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre" 	returnvariable="LvarNombre"> <!--- ConcatenarNombres--->
	<cf_dbfunction name="string_part" args="#LvarNombre#|1|30" 	returnvariable="LvarSPNombre"  delimiters="|"> <!--- Primero 30 caracteres--->
 
 
   <!--- Formateo FechaEmi : Fecha de Emision --->
 <!---Se desea: formato: ddmmaaaa, solo digitos--->
  <!---Longitud : 8--->
  
 <cf_dbfunction name="now" 	 returnvariable="hoy" >
 <cf_dbfunction name="date_format"	args="#hoy#,ddmmyyyy" returnvariable="LvarFechaFinal">


 <!--- Formateo Monto  --->
 <!--- monto sin punto decimal pero con 2 decimales--->
  <!---Longitud : 30--->
  
		<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
               <cf_dbfunction name="to_number"	args="coalesce(a.DRNliquido, 0)*100" returnvariable="LvarMontoNum"><!---proceso---->
           <cfelse>
                <cf_dbfunction name="to_number"	args="coalesce(a.HDRNliquido, 0)*100" returnvariable="LvarMontoNum"> <!--- historico---->
          </cfif>     
          
        <cf_dbfunction name="to_char_integer" args="#LvarMontoNum#"  returnvariable="LvarMontoChar">
    
     <!--- Formateo patrono  --->
     <cf_dbfunction name="to_char_integer"	args="#rsPatrono.patrono#" returnvariable="LvarPatrono">
    

<cfquery datasource="#session.DSN#">
	insert into #datos_temp#(	DEid,
								cedula, 
								nombre, 
								fechaemi, 
								tipo, 
								entidad, 
								motivo, 
								moneda, 
								servicio, 
								idnegocio, 
								negocio,
								centrocosto, 
								ctacliente,
								monto,
								documento,
								iddestino,
								titularservicio,
								patrono
						    )

		select 	a.DEid,
        		#preservesinglequotes(LvarSPCedula)#	   as cedula, 
				#preservesinglequotes(LvarSPNombre)#	  as nombre, 
    			 #preserveSingleQuotes(LvarFechaFinal)# as FechaEmi,
                'C' as tipo,<!--- Crédito al empleado--->
				'161' as entidad,<!--- codigo del Banco Popular--->
				'01' as motivo,   <!--- tramite interbancario--->
				case when m.Miso4217 =  'CRC' then '1' 
                		  when m.Miso4217 =  'USD' then '2' 
                  			else '1'  end as moneda,
              <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
              			ERNdescripcion
                 <cfelse>
						HERNdescripcion
                 </cfif>  as servicio, <!--- descripcion de la nómina que se esta ejecutando--->
				<cfqueryparam cfsqltype="cf_sql_char" value="#cedula_juridica#"> as IDNegocio,				
				<cfqueryparam cfsqltype="cf_sql_char" value="#empresa#"> as negocio,
				(	select max(CFcodigo)
					from CFuncional cf
		                        inner join RHPlazas p
									 on p.CFid=cf.CFid                                
								<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
                                    inner join PagosEmpleado hp
                                 <cfelse>
                                    inner join HPagosEmpleado hp                                
                                    </cfif>     		                    
                                    on  hp.RHPid = p.RHPid
                                    and  b.RCNid=hp.RCNid
                                    and de.DEid=hp.DEid
                                    and PEtiporeg=0 <!---  Pagor Ordinarios, no considero retroactivos--->
				 ) as centrocosto, <!--- Centro de Costos donde se encontraba el empleado --->
				de.CBcc as CtaCliente, <!--- Cuenta Cliente del Empleado 17 digitos --->
				#preservesinglequotes(LvarMontoChar)# as monto,				
				' ' as documento,
				' ' as idDestino,
				' ' as TitularServicio,
				#preservesinglequotes(LvarPatrono)#  as patrono <!--- Codigo Patrono 4 digitos de la Empresa hacia el Banco --->
              <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
			     	from DRNomina a
	                     inner join ERNomina b
        	             on b.ERNid=a.ERNid 
				 <cfelse>
			     	from HDRNomina a
	                     inner join HERNomina b
        	             on b.ERNid=a.ERNid                                                                  
				</cfif>                                  

    	                inner join DatosEmpleado de
	    	                on de.DEid=a.DEid
                	    inner join Monedas m
                        	on m.Mcodigo=a.Mcodigo
	           where  a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
              and de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
               <cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "p">
                          and a.DRNliquido > 0
                         and a.DRNestado =1 <!---si es una nomina en proceso y  DRNestado es 1 para mostrar los empleados que se les pagarán, de lo contrario el valor sería 2=no se pagaran---->
                 <cfelse>
                          and a.HDRNliquido > 0
                          and a.HDRNestado =1 <!---si es una nomina en historico y  HDRNestado es 1 para mostrar los empleados que se les pagarán, de lo contrario el valor sería 2=no se pagaran---->
                </cfif>
</cfquery>

<!--- quita los caracteres que no son letras ni digitos del nombre del empleado --->
<cfquery name="rs_nombre" datasource="#session.DSN#">
	select DEid, nombre,centrocosto from #datos_temp#
</cfquery>

<cfloop query="rs_nombre"><!--- se encarga de eliminar tildes del nombre .según lo especificado en el documento--->
			<cfset nombre_nuevo = lcase(rs_nombre.nombre) > <!--- coloca el dato en minusculas --->
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"á","a","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"é","e","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"í","i","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ó","o","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ú","u","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ñ","n","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ä","a","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ë","e","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ï","i","ALL") >			
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ö","o","ALL") >
            <cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ü","u","ALL") >		
            <cfset nombre_nuevo = REReplaceNoCase(nombre_nuevo,"[^A-Za-z0-9 ]","","ALL") >
            <cfset nombre_nuevo = ucase(nombre_nuevo) >	
			
			<cfset nombre_centro = rs_nombre.centrocosto>
			
			<cfif not IsNumeric(#nombre_centro#)><!---valor por default del centro funcional para el caso de la nacion--->
				<cfset nombre_centro=1020>
			</cfif>
            
            <cfquery datasource="#session.DSN#">
                update #datos_temp#
                set nombre = <cfqueryparam cfsqltype="cf_sql_char" value="#nombre_nuevo#">,
				 	centrocosto = <cfqueryparam cfsqltype="cf_sql_char" value="#nombre_centro#">
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nombre.DEid#">
            </cfquery>
</cfloop>



<!--------------------------------------------------------------- FORMATEO DE CAMPOS POSConsulta -------------------------------------------------------------------------------->

<cf_dbfunction name="to_char_integer"	args="0"  returnvariable="cero"><!--- se convierte a cero el string para usarlo como char a duplicar--->
			
<!--- CEDULA--->
<cf_dbfunction name="chr" args="9" returnvariable="chrtab">
<cf_dbfunction name="sReplace"	args="cedula,#chrtab#,''"  returnvariable="LBcedula">
 <cf_dbfunction name="string_part" args="rtrim(#LBcedula#)|1|10" 	returnvariable="LvarCedula"  delimiters="|">  <!--- Primero 10 --->
	<cf_dbfunction name="length"      args="#LvarCedula#"  		returnvariable="LvarCedulaL" delimiters="|" > <!--- Longitud Real--->
		<cf_dbfunction name="sRepeat"     args="#cero#|10-coalesce(#LvarCedulaL#,0)" 	returnvariable="ReplCedula" delimiters="|">				


<!--- Nombre--->
<cf_dbfunction name="sReplace"	args="nombre,#chrtab#,''"  returnvariable="LBnombre">
 <cf_dbfunction name="string_part" args="rtrim(#LBnombre#)|1|30" 	returnvariable="LvarNombre"  delimiters="|">  <!--- Primero 30 --->
		<cf_dbfunction name="length"      args="#LvarNombre#"  		returnvariable="LvarNombreL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|30-coalesce(#LvarNombreL#,0)" 	returnvariable="ReplNombre" delimiters="|">
                
<!--- fechaemi--->
<cf_dbfunction name="sReplace"	args="fechaemi,#chrtab#,''"  returnvariable="LBfechaemi">
 <cf_dbfunction name="string_part" args="rtrim(#LBfechaemi#)|1|8" 	returnvariable="LvarFechaemi"  delimiters="|">  <!--- Primero 8 --->
		<cf_dbfunction name="length"      args="#LvarFechaemi#"  		returnvariable="LvarFechaemiL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|8-coalesce(#LvarFechaemiL#,0)" 	returnvariable="ReplFechaemi" delimiters="|">
        

<!--- Motivo--->
 <cf_dbfunction name="string_part" args="rtrim(motivo)|1|2" 	returnvariable="LvarMotivo"  delimiters="|">  <!--- Primero 2 --->
		<cf_dbfunction name="length"      args="#LvarMotivo#"  		returnvariable="LvarMotivoL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|2-coalesce(#LvarMotivoL#,0)" 	returnvariable="ReplMotivo" delimiters="|">

<!--- Moneda--->
 <cf_dbfunction name="string_part" args="rtrim(moneda)|1|1" 	returnvariable="LvarMoneda"  delimiters="|">  <!--- Primero 1 --->
		<cf_dbfunction name="length"      args="#LvarMoneda#"  		returnvariable="LvarMonedaL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|1-coalesce(#LvarMonedaL#,0)" 	returnvariable="ReplMoneda" delimiters="|">

<!--- servicio--->
<cf_dbfunction name="sReplace"	args="servicio,#chrtab#,''"  returnvariable="LBservicio">
 <cf_dbfunction name="string_part" args="rtrim(#LBservicio#)|1|20" 	returnvariable="LvarServicio"  delimiters="|">  <!--- Primero 20 --->
		<cf_dbfunction name="length"      args="#LvarServicio#"  		returnvariable="LvarServicioL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|20-coalesce(#LvarServicioL#,0)" 	returnvariable="ReplServicio" delimiters="|">

<!--- idnegocio--->
<cf_dbfunction name="sReplace"	args="idnegocio,#chrtab#,''"  returnvariable="LBidnegocio">
 <cf_dbfunction name="string_part" args="rtrim(#LBidnegocio#)|1|20" 	returnvariable="LvarIdnegocio"  delimiters="|">  <!--- Primero 20 --->
		<cf_dbfunction name="length"      args="#LvarIdnegocio#"  		returnvariable="LvarIdnegocioL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|20-coalesce(#LvarIdnegocioL#,0)" 	returnvariable="ReplIdnegocio" delimiters="|">


<!--- negocio--->
<cf_dbfunction name="sReplace"	args="negocio,#chrtab#,''"  returnvariable="LBnegocio">
 <cf_dbfunction name="string_part" args="rtrim(#LBnegocio#)|1|20" 	returnvariable="LvarNegocio"  delimiters="|">  <!--- Primero 20 --->
		<cf_dbfunction name="length"      args="#LvarNegocio#"  		returnvariable="LvarNegocioL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|20-coalesce(#LvarNegocioL#,0)" 	returnvariable="ReplNegocio" delimiters="|">

<!--- centrocosto--->

 <cf_dbfunction name="string_part" args="rtrim(centrocosto)|1|4" 	returnvariable="LvarCentrocosto"  delimiters="|">  <!--- Primero 4 --->
		<cf_dbfunction name="length"      args="#LvarCentrocosto#"  		returnvariable="LvarCentrocostoL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|4-coalesce(#LvarCentrocostoL#,0)" 	returnvariable="ReplCentrocosto" delimiters="|">

<!--- ctacliente--->
<cf_dbfunction name="sReplace"	args="ctacliente,#chrtab#,''"  returnvariable="LBctacliente">
 <cf_dbfunction name="string_part" args="rtrim(#LBctacliente#)|1|17" 	returnvariable="LvarCtacliente"  delimiters="|">  <!--- Primero 17 --->
		<cf_dbfunction name="length"      args="#LvarCtacliente#"  		returnvariable="LvarCtaclienteL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|17-coalesce(#LvarCtaclienteL#,0)" 	returnvariable="ReplCtacliente" delimiters="|">
                
<!--- monto--->
 <cf_dbfunction name="string_part" args="rtrim(monto)|1|15" 	returnvariable="LvarMonto"  delimiters="|">  <!--- Primero 15 --->
		<cf_dbfunction name="length"      args="#LvarMonto#"  		returnvariable="LvarMontoL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="#cero#|15-coalesce(#LvarMontoL#,0)" 	returnvariable="ReplMonto" delimiters="|">


<!--- documento--->
<cf_dbfunction name="sRepeat"     args="''|20" 	returnvariable="ReplDocumento" delimiters="|">
 <cf_dbfunction name="string_part" args="rtrim(documento)|1|20" 	returnvariable="LvarDocumento"  delimiters="|">  <!--- Primero 20 --->


<!--- iddestino--->
 <cf_dbfunction name="string_part" args="rtrim(iddestino)|1|20" 	returnvariable="LvarIddestino"  delimiters="|">  <!--- Primero 20 --->
	<cf_dbfunction name="sRepeat"     args="''|20" 	returnvariable="ReplIddestino" delimiters="|">

<!--- Titularservicio--->
 <cf_dbfunction name="string_part" args="rtrim(titularservicio)|1|25" 	returnvariable="LvarTitularservicio"  delimiters="|">  <!--- Primero 25 --->
	<cf_dbfunction name="sRepeat"     args="''|25" 	returnvariable="ReplTitularservicio" delimiters="|">
                
<!--- patrono--->
 <cf_dbfunction name="string_part" args="rtrim(patrono)|1|4" 	returnvariable="LvarPatrono"  delimiters="|">  <!--- Primero 4 --->
		<cf_dbfunction name="length"      args="#LvarPatrono#"  		returnvariable="LvarPatronoL" delimiters="|" > <!--- Longitud Real--->
				<cf_dbfunction name="sRepeat"     args="''|4-coalesce(#LvarPatronoL#,0)" 	returnvariable="ReplPatrono" delimiters="|">

		

	<cfquery name="ERR" datasource="#session.DSN#">
		select 	
        		left(#ReplCedula# #concat# #LBcedula#,10) #concat# <!--- cédula del cliente destino--->
                
        		right(#LBnombre# #concat# #ReplNombre#,30)#concat#<!---nombre del cliente destino--->
                
				left(#LBfechaemi# #concat# #ReplFechaemi#,8)#concat#<!---fecha de emision--->
					
				left(tipo,1)#concat#<!--- tipo de transaccion D=debito, C=Credito--->
                
				left(entidad,3)#concat#<!--- codigo de la entidad financiera de destino--->
                
                left(motivo#concat##ReplMotivo#,2)#concat#<!--- para un archivo de envio 01=trámite interbancario--->
                 
                left(moneda#concat##ReplMoneda#,1)#concat#<!---tipo de moneda 1=colones, 2=dolares--->
                
                left(#LBservicio# #concat##ReplServicio#,20)#concat#<!---crédito o debito--->

				left(#LBidnegocio# #concat##ReplIdnegocio#,20)#concat#<!---identificacion del negocio (cliente origen)--->
                
                left(#LBnegocio# #concat##ReplNegocio#,20)#concat#<!---nombre del negocio (cliente origen)--->
                
                left(centrocosto#concat##ReplCentrocosto#,4)#concat#<!---debe ser proporcionado por el negocio y sirve para control interno--->
                
                left(#LBctacliente# #concat##ReplCtacliente#,17)#concat#<!---numero de cuenta del cliente destino--->
 
				right(#ReplMonto##concat#monto,15)#concat#<!--- corresponde al monto que se le debe debitar al cliente--->

				left(#LvarDocumento##concat##ReplDocumento#,20)#concat#<!---debido o crédito--->

          	 	left(#LvarIddestino##concat##ReplIddestino#,20)#concat#<!---debido o crédito--->
				
        	   	left(#LvarTitularservicio##concat##ReplTitularservicio#,25)#concat#<!---debido o crédito---->

				left(patrono#concat##ReplPatrono#,4)<!--- codigo de patrono asignado por el banco popular--->

		from #datos_temp#
	</cfquery>
	