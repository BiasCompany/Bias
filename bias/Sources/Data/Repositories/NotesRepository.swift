//
//  NotesRepository.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//



protocol NotesRepository {
    func saveNote(_ note: Note) async throws
    func getNotes() async throws -> [Note]
    func deleteNote(_ note: Note) async throws
}

final class NotesRepositoryImpl: NotesRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    func saveNote(_ note: Note) async throws {
        try await ds.saveNote(note)
    }

    func getNotes() async throws -> [Note] {
        return try await ds.getNotes()
    }

    func deleteNote(_ note: Note) async throws {
        try await ds.deleteNote(note)
    }
}
