//
//  NotesService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol NotesService {
    func getNotes() throws -> [Note]
    func getNote(note: Note) throws -> Note?
    func updateNote(note: Note) throws
}

class NotesServiceImpl: NotesService {
    var repo: NotesRepository
    
    init(repo: NotesRepository) {
        self.repo = repo
    }
    
    func getNotes() throws -> [Note] {
        try repo.getNotes()
    }
    
    func getNote(note: Note) throws -> Note? {
        try repo.getNote(note: note)
    }
    
    func updateNote(note: Note) throws {
        let noteDb = try getNote(note: note)
        if noteDb == nil {
            print("daveeee")
            try repo.saveNote(note)
        } else {
            print("updaeetee")
            try repo.updateNote(note)
        }
    }
    

}
