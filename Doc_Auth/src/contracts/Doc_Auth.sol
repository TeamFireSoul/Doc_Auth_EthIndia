pragma solidity ^0.4.18;

import '../openzeppelin-solidity/contracts/examples/RBACWtihAdmin.sol';


contract Doc_Auth is RBAC {
    struct Doctor {
        uint certificate_no;
        address medi_institute;
        string  nameOfDoc;
        uint age;
        string sex;
        bool isQualified;  
   }
    
    mapping (uint256 => Doctor) public Doctors;

    event DoctorCreatedEvent(
        uint certificate_no,
        address medi_institute,
        string  nameOfDoc,
        uint age,
        string sex,
        bool isQualified
    );
    
    function setDoctor (
        string _nameOfDoc,
        uint _age,
        uint _certificate_no,
        string _sex
    ) public onlyRole("Medi_Institute")
    {
        require(Doctors[_certificate_no].certificate_no == 0);

        var Doc = Doctors[_certificate_no];
        Doc.medi_institute = msg.sender;
        Doc.nameOfDoc = _nameOfDoc;
        Doc.age = _age;
        Doc.sex = _sex;
        
        Doc.isQualified = true;
       

        // set all values and put in event
        DoctorCreatedEvent(_certificate_no, msg.sender, _nameOfDoc, _age, _sex, 
            Doc.isQualified);
    }

    event IsPrescribing(
        uint certificate_no,
        address medi_institute,
        string  nameOfDoc,
        uint age,
        string sex,
        bool isQualified
    );


    function Is_Prescribing (
        uint _certificate_no, 
        bool _isQualified
    ) public onlyRole("TheDoc")
    {
        require(Doctors[_certificate_no].medi_institute != 0);
        
        Doctors[_certificate_no].isQualified = _isQualified;
        Doctors[_certificate_no].medi_institute = msg.sender;
        IsPrescribing(_certificate_no, Doctors[_certificate_no].medi_institute, Doctors[_certificate_no].nameOfDoc,Doctors[_certificate_no].age, Doctors[_certificate_no].sex, Doctors[_certificate_no].isQualified);
    }

    
}