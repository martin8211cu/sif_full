<!---
desde tag <br>
<cf_cuentas_auto
  Tabla='Oficinas'  
  ODChar="123" 
  Oorigen="CPFC"
>
 debug="yes" 
 --->
<br> desde funcion <br>

<cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Cuentas" method="TraeCuenta" 
	Oorigen="CPFC"
	Ecodigo="#Session.Ecodigo#"
	Conexion="#Session.DSN#"
	Almacen ='A2'
	Articulos ='ART'	
	Oficinas ='OFI'	       
	CCTransacciones =''
	Conceptos ='CC'
	Monedas ='MND'
	SNegocios  =''
	CConceptos=''
	CFuncional='CF'
	CPTransacciones=''
	Clasificaciones =''
>
</cfinvoke>		
<cfdump var="#Cuentas#">
