//
//  NotesRepository.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol NotesRepository {
    func saveNote(_ note: Note) throws
    func getNotes() throws -> [Note]
    func getNote(note: Note) throws -> Note?
    func updateNote(_ note: Note) throws
    func deleteNote(_ note: Note) throws
}

final class NotesRepositoryImpl: NotesRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    func saveNote(_ note: Note) throws {
        try ds.saveNote(note)
    }

    func getNotes() throws -> [Note] {
        return try ds.getNotes()
    }
    
    func getNote(note: Note) throws -> Note? {
        return try ds.getNotes().filter { $0.id == note.id }.first
    }
    
    func updateNote(_ note: Note) throws {
        return try ds.editNotes(note)
    }

    func deleteNote(_ note: Note) throws {
        try ds.deleteNote(note)
    }
}


